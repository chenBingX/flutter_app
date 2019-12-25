# coding=utf-8
import os
import sys
import shutil
import requests
import zipfile
import re

if sys.version > '3':
    import urllib.request
else:
    from urllib import unquote

base_url = 'http://gitlab.alibaba-inc.com/{group}/{widget}'
tags_page_url = base_url + '/tags'
tags_flag = 'href="/{group}/{widget}/tags/'
page_flag = 'href="/{group}/{widget}/tags?page='
tag_zip_url = base_url + '/repository/archive.zip?ref={version}'


def print_error(s):
    print ('\033[0;31mError: {content}\033[0m'.format(content=s))


def print_color(s, mode='0', color='37'):
    return '\033[{mode};{color}m{content}\033[0m'.format(mode=mode, color=color, content=s)


# text是否包含content
def is_contain(text, content):
    text = str(text)
    content = str(content)
    if text.find(content) != -1:
        return True
    else:
        return False


def is_empty(s):
    return s is None or len(s) == 0


def runCmd(cmd):
    # print (cmd)
    f = os.popen(cmd)
    text = f.read()
    f.close()
    return text


def decode(s):
    if sys.version > '3':
        return urllib.request.unquote(s)
    else:
        return unquote(s)


def get_name_in_yaml(yaml_path):
    name = ''
    with open(yaml_path, mode='r') as projects_yaml:
        lines = projects_yaml.readlines()
        for line in lines:
            if line.startswith("name:"):
                name = line.strip().lstrip().rstrip(',').replace(' ', '').split(':')[1]
                break
    return name


def get_projects_name():
    return get_name_in_yaml("pubspec.yaml")


def merge_yaml(local_path, widget_yaml_path):
    with open(widget_yaml_path, mode='r') as widget_yaml:
        assert_begin = False
        widget_name = ''
        assets = []
        for line in widget_yaml:
            if line.startswith("name:"):
                line = line.strip().lstrip().rstrip(',').replace(' ', '')
                widget_name = line.split(':')[1]
            elif line.startswith("  assets:"):
                assert_begin = True
            elif assert_begin and line.startswith("    - packages/{name}/".format(name=widget_name)):
                assets.append(line)
        # print (assets)
        # if len(assets) == 0:
        #     return
        if not os.path.exists('pubspec.yaml'):
            print_error("项目缺少 pubspec.yaml 配置文件，请检查项目配置文件是否存在或路径是否正确")
            return
        # 项目配置文件
        with open("pubspec.yaml", mode='r+') as projects_yaml:
            project_name = ''
            new_assets = []
            lines = projects_yaml.readlines()
            has_asserts_tag = "  assets:\n" in lines
            for line in lines:
                if line.startswith("name:"):
                    project_name = line.strip().lstrip().rstrip(',').replace(' ', '').split(':')[1]
                    # 生成 project 对应的资源
                    for res in assets:
                        new_assets.append(
                            res.replace(widget_name, project_name + local_path.replace('lib', '') + widget_name))
                    # print(new_assets)
            # 删除原有组件依赖的资源
            remove_assets = []
            for line in lines:
                if line.startswith("    - packages/{name}/".format(
                        name=(project_name + local_path.replace('lib', '') + widget_name))):
                    remove_assets.append(line)
            for line in remove_assets:
                if line in lines:
                    lines.remove(line)
                elif line.replace("\n", '') in lines:
                    lines.remove(line.replace("\n", ''))
            if not len(new_assets) == 0:
                # 添加新的资源依赖
                if has_asserts_tag:
                    assert_tag_index = lines.index("  assets:\n")
                    line_count = 1
                    for line in new_assets:
                        lines.insert(assert_tag_index + line_count, line)
                        line_count = line_count + 1
                else:
                    flutter_tag_index = lines.index("flutter:\n")
                    assert_tag_index = flutter_tag_index + 1
                    lines.insert(assert_tag_index, '  assets:\n')
                    line_count = 1
                    for line in new_assets:
                        lines.insert(assert_tag_index + line_count, line)
                        line_count = line_count + 1
            projects_yaml.seek(0)
            projects_yaml.truncate()
            projects_yaml.writelines(lines)


def delete_temp_file(widget, temp_file):
    try:
        os.unlink(widget + ".zip")
        shutil.rmtree(temp_file)
        print ("清理 " + widget + " 组件临时文件完成")
    except (IOError, OSError):
        print_error("组件临时文件清理过程中遇到错误！")


def get_files(root_path):
    def inner_get_file_path(root_path, file_list, dir_list):
        # 获取该目录下所有的文件名称和目录名称
        dir_or_files = os.listdir(root_path)
        for dir_file in dir_or_files:
            # 获取目录或者文件的路径
            dir_file_path = os.path.join(root_path, dir_file)
            # 判断该路径为文件还是路径
            if os.path.isdir(dir_file_path):
                dir_list.append(dir_file_path)
                # 递归获取所有文件和目录的路径
                inner_get_file_path(dir_file_path, file_list, dir_list)
            else:
                file_list.append(dir_file_path)

    file_list = []
    dir_list = []
    inner_get_file_path(root_path, file_list, dir_list)
    return file_list


def change_import(project_name, local_path, widget_name):
    path = local_path + widget_name + '/'
    widget_import_prefix = "import 'package:" + widget_name + "/"
    project_import_prefix = "import 'package:" + project_name + path.replace('lib', '')
    # 用来存放所有的文件路径
    file_paths = get_files(path)
    # print(file_paths)
    for file_path in file_paths:
        if file_path.endswith(".dart"):
            with open(file_path, "r+") as file_reader:
                lines = file_reader.readlines()
                for line in lines:
                    if is_contain(line, widget_import_prefix):
                        lines.remove(line)
                        lines.insert(0, line.replace(widget_import_prefix, project_import_prefix))
                file_reader.seek(0)
                file_reader.truncate()
                file_reader.writelines(lines)


def update_widget(local_path, group, widget, version):
    try:
        shutil.rmtree(local_path + widget)
    except (IOError, OSError):
        pass
        # print("尝试清理老版本 " + widget + " 组件失败！可能的原因是，此前尚未引入该组件.")
    else:
        print("清理老版本 " + widget + " 组件成功")
    url = tag_zip_url.format(group=group, widget=widget, version=version)
    print (widget + " 组件下载URL：" + url)
    zipfile_name = widget + ".zip"
    response = requests.get(url)
    if len(response.content) == 0:
        print_error('组件下载失败，URL: ' + url)
        print(print_color(s='Failure!', color='35'))
        return
    with open(zipfile_name, "wb") as code:
        code.write(response.content)
        print("下载 " + widget + " 组件成功")
    with zipfile.ZipFile(zipfile_name, mode='r') as zip:
        # 生成临时文件
        temp_file = "temp_" + widget
        zip.extractall(temp_file)
        success = False
        lib_path = zip.namelist()[0] + "lib/"
        if not lib_path in zip.namelist():
            print_error(
                ("未在 {widget} 组件中找到 ".format(widget=widget)) + print_color('lib/', '4', '34') + print_color(
                    s=" 路径。这是一个 Flutter 组件？（组件下载URL: ", color='31') + url + print_color(s="）", color='31'))
            delete_temp_file(widget, temp_file)
            print(print_color(s='Failure!', color='35'))
            return
        widget_yaml_path = temp_file + "/" + zip.namelist()[0] + "pubspec.yaml"
        if not os.path.exists(widget_yaml_path):
            print_error("组件缺少 pubspec.yaml 配置文件，请检查组件配置文件是否存在或路径是否正确。组件URL: " + url)
            delete_temp_file(widget, temp_file)
            print(print_color(s='Failure!', color='35'))
            return
        merge_yaml(local_path, widget_yaml_path)
        # 拷贝组件源码到local_path
        for file in zip.namelist():
            # print (file)
            if file.endswith(lib_path):
                if not local_path.endswith("/"):
                    local_path = local_path + "/"
                shutil.move(temp_file + "/" + file, local_path + widget)
                success = True
                print (widget + " 组件更新成功，路径：" + print_color(local_path + widget + "/", '4', '34'))
                if os.path.exists('pubspec.yaml'):
                    try:
                        change_import(get_projects_name(), local_path, get_name_in_yaml(widget_yaml_path))
                        print("组件 import 依赖已更新。如有必要，请检查各文件的依赖关系")
                    except Exception:
                        print_error("组件 import 依赖更新失败。请手动检查各文件依赖关系")
                        pass
                else:
                    print_error("项目缺少 pubspec.yaml 配置文件，请检查项目配置文件是否存在或路径是否正确")
                break
        # 删除临时文件
        delete_temp_file(widget, temp_file)
        if success:
            runCmd("git add " + (local_path + widget))
            print(print_color(s='Done!', color='32'))
        else:
            print(print_color(s='Failure!', color='35'))


def get_all_pages_tags(pages, group, widget):
    tags = []
    if len(pages) > 0:
        for num in pages:
            temp_tags_page_url = tags_page_url.format(group=group, widget=widget) + "?page=" + num
            temp_tags_page_response = requests.get(temp_tags_page_url)
            if len(temp_tags_page_response.content) == 0:
                return tags
            for xml_line in temp_tags_page_response.content.splitlines():
                if not is_empty(xml_line):
                    temp_tags_flag = tags_flag.format(group=group, widget=widget)
                    if is_contain(xml_line, temp_tags_flag):
                        tag = (xml_line[
                               xml_line.find(temp_tags_flag) + len(temp_tags_flag):xml_line.rfind(
                                   '"')])
                        # print("获取到Tag2: " + tag)
                        tags.append(tag)
    return tags


def get_first_tags_and_pages(group, widget):
    tags_and_pages = []
    tags = []
    pages = []
    temp_tags_page_url = tags_page_url.format(group=group, widget=widget)
    print ("组件URL: " + temp_tags_page_url)
    temp_tags_page_response = requests.get(temp_tags_page_url)
    if len(temp_tags_page_response.content) == 0:
        return tags_and_pages
    for xml_line in temp_tags_page_response.content.splitlines():
        xml_line = str(xml_line)
        if not is_empty(xml_line):
            temp_tags_flag = tags_flag.format(group=group, widget=widget)
            temp_tags_flag = str(temp_tags_flag)
            temp_page_flag = page_flag.format(group=group, widget=widget)
            if is_contain(xml_line, temp_tags_flag):
                tag = (
                    xml_line[
                    xml_line.find(temp_tags_flag) + len(temp_tags_flag):xml_line.rfind('"')])
                # print(xml_line)
                # print("获取到Tag1: " + tag)
                tags.append(tag)
            if is_contain(xml_line, temp_page_flag):
                page_num = xml_line[
                           xml_line.find(temp_page_flag) + len(temp_page_flag):xml_line.rfind('"')]
                # print("获取到PageNum: " + page_num)
                pages.append(page_num)
    tags_and_pages.append(tags)
    tags_and_pages.append(pages)
    return tags_and_pages


def version_compare(v1, v2):
    d1 = re.split('\.', v1)
    d2 = re.split('\.', v2)
    d1 = [int(d1[i]) for i in range(len(d1))]
    d2 = [int(d2[i]) for i in range(len(d2))]
    if d1 > d2:
        return 1
    if d1 < d2:
        return -1
    if d1 == d2:
        return 0


def find_best_version(version, tags):
    if is_empty(version) or len(tags) == 0:
        return ''
    tag_x = decode(tags[0]).split('.')[0]
    prefix = tag_x[0:tag_x.find(re.findall(r"\d+", tag_x)[0])]
    if version == '*':
        # 降序排
        tags.sort(key=lambda x: tuple(int(v) for v in decode(x).replace(prefix, '').split(".")),
                  reverse=True)
        return tags[0]
    elif is_contain(version.lower(), 'x'):
        tags.sort(key=lambda x: tuple(int(v) for v in decode(x).replace(prefix, '').split(".")))
        split_version = version.split('.')
        x = split_version[0]
        y = split_version[1]
        z = split_version[2]
        # 主版本号不能为 x
        if x.lower() == 'x':
            return ''
        if y.lower() == 'x':
            min_x = int(x)
            min_y = 0
            min_z = 0
            max_x = int(x) + 1
            max_y = 0
            max_z = 0
            min_version = '{x}.{y}.{z}'.format(x=str(min_x), y=str(min_y), z=str(min_z))
            max_version = '{x}.{y}.{z}'.format(x=str(max_x), y=str(max_y), z=str(max_z))
            best_version = ''
            for tag in tags:
                temp_tag = decode(tag).replace(prefix, '')
                if version_compare(temp_tag, min_version) >= 0 and version_compare(temp_tag,
                                                                                   max_version) == -1:
                    best_version = tag
            return best_version
        elif z.lower() == 'x':
            min_x = int(x)
            min_y = 0
            min_z = 0
            max_x = int(x)
            max_y = int(y) + 1
            max_z = 0
            min_version = '{x}.{y}.{z}'.format(x=str(min_x), y=str(min_y), z=str(min_z))
            max_version = '{x}.{y}.{z}'.format(x=str(max_x), y=str(max_y), z=str(max_z))
            best_version = ''
            for tag in tags:
                temp_tag = decode(tag).replace(prefix, '')
                if version_compare(temp_tag, min_version) >= 0 and version_compare(temp_tag,
                                                                                   max_version) == -1:
                    best_version = tag
            return best_version
    elif is_contain(version, '^'):
        # 升序排序
        tags.sort(key=lambda x: tuple(int(v) for v in decode(x).replace(prefix, '').split(".")))
        version = version[1:]
        split_version = version.split('.')
        max_x = x = int(split_version[0])
        max_y = y = int(split_version[1])
        max_z = z = int(split_version[2])
        if not x == 0:
            max_x = x + 1
            max_y = 0
            max_z = 0
        elif not y == 0:
            max_y = y + 1
            max_z = 0
        else:
            max_z = z + 1
        max_version = '{x}.{y}.{z}'.format(x=str(max_x), y=str(max_y), z=str(max_z))
        best_version = ''
        for tag in tags:
            temp_tag = decode(tag).replace(prefix, '')
            if version_compare(temp_tag, version) >= 0 and version_compare(temp_tag,
                                                                           max_version) == -1:
                best_version = tag
        return best_version
    elif is_contain(version, '~'):
        # 升序排序
        tags.sort(key=lambda x: tuple(int(v) for v in decode(x).replace(prefix, '').split(".")))
        version = version[1:]
        split_version = version.split('.')
        max_x = int(split_version[0])
        max_y = int(split_version[1]) + 1
        max_z = 0
        max_version = '{x}.{y}.{z}'.format(x=str(max_x), y=str(max_y), z=str(max_z))
        best_version = ''
        for tag in tags:
            temp_tag = decode(tag).replace(prefix, '')
            if version_compare(temp_tag, version) >= 0 and version_compare(temp_tag,
                                                                           max_version) == -1:
                best_version = tag
        return best_version
    else:
        best_version = ''
        for tag in tags:
            temp_tag = decode(tag).replace(prefix, '')
            if version == temp_tag:
                best_version = tag
        return best_version


def handle_flutter_ui():
    split = "--------------------------------------------------------------------------------------------------------------------------------------------------------------"
    local_path = "/lib/widget/"
    group = 'fapi'
    widget = 'button'
    version = "0.0.1"
    if not os.path.exists("flutter_ui.yaml"):
        print_error("项目缺少 flutter_ui.yaml 配置文件，请检查项目配置文件是否存在或路径是否正确。如果还未生成该配置文件，请在项目根目录创建 flutter_ui.yaml 配置文件")
        return
    with open("flutter_ui.yaml", "r") as file:
        for line in file:
            line = line.strip().lstrip().rstrip(',').replace(' ', '')
            if line.startswith("#"):
                continue
            if is_contain(line, "=") or is_contain(line, ":"):
                # print ("读取到的内容：\n" + line)
                # 读取到存放路径
                if line.startswith("path"):
                    local_path = line.replace('path=', '').replace('"', '')
                    if not local_path.endswith("/"):
                        local_path = local_path + "/"
                    print ('\nlocal_path: ' + print_color(local_path, '4', '34'))
                    print (split)
                # 读取到group
                elif line.startswith("group"):
                    group = line.replace('group=', '').replace('"', '')
                    print ('group: ' + print_color(s=group, color='33'))
                    print (split)
                # 读取到依赖
                elif is_contain(line, ':'):
                    split_line = line.split(':')
                    if len(split_line) == 2:
                        widget = split_line[0]
                        version = split_line[1]
                        print ('widget: ' + print_color(s=widget, color='33'))
                        print ('version: ' + print_color(s=version, color='33'))
                        try:
                            # 获取第一页的Tags和
                            tags_and_pages = get_first_tags_and_pages(group, widget)
                            if len(tags_and_pages) != 2 or len(tags_and_pages[0]) == 0:
                                print_error("未找到组件 " + widget + ": " + version)
                                print(print_color(s='Failure!', color='35'))
                                print(split)
                                return
                            tags = tags_and_pages[0]
                            pages = tags_and_pages[1]
                            # 获取其它页的Tag
                            if len(pages) > 0:
                                tags.extend(get_all_pages_tags(pages, group, widget))
                            # print(pages)
                            print("共发现组件 " + widget + " 版本 " + print_color(s=str(len(tags)), color='33') + " 个")
                            # print(tags)
                            best_version = find_best_version(version, tags)
                            if not is_empty(best_version):
                                print('已匹配最佳版本：' + print_color(s=decode(best_version), color='33'))
                                update_widget(local_path, group, widget, best_version)
                            else:
                                print_error(widget + " 组件未找到适合的版本号，请重检查版本号配置！当前版本号配置为：" + version)
                        except (Exception):
                            print_error("拉取组件失败，请检查配置文件")
                        print(split)


handle_flutter_ui()
