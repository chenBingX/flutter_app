# coding=utf-8
import os
import shutil
import requests
import zipfile

group = 'rpi'
widget = 'button'
version = "0.2.0"


# text是否包含content
def is_contain(text, content):
    if text.find(content) != -1:
        return True
    else:
        return False


def is_empty(s):
    return len(s) == 0


def update_widget(local_path, group, widget, version):
    base_url = 'http://gitlab.alibaba-inc.com/{group}/{widget}/repository/archive.zip?ref=publish/{version}'
    url = base_url.format(group=group, widget=widget, version=version)
    print (widget + " 组件地址：" + url)
    response = requests.get(url)
    with open(widget + ".zip", "wb") as code:
        code.write(response.content)
        try:
            shutil.rmtree("lib/widget/" + widget)
        except IOError:
            print("清理老版本 " + widget + " 组件失败！可能的原因是，此前尚未引入该组件.")
        else:
            print("清理老版本 " + widget + " 组件成功！")
        with zipfile.ZipFile(widget + ".zip", 'r') as zip:
            temp_file = "temp_" + widget
            zip.extractall(temp_file)
            for file in zip.namelist():
                if file.endswith("/src/"):
                    if not local_path.endswith("/"):
                        local_path = local_path + "/"
                    shutil.move(temp_file + "/" + file, local_path + widget)
                    print (widget + " 组件更新成功!")
                    break
            os.unlink(widget + ".zip")
            shutil.rmtree(temp_file)
            print ("清理 " + widget + " 组件临时文件完成!")
            print ("-----------")


local_path = "/lib/widget/"
with open("flutter_ui.txt", "r") as file:
    for line in file:
        line = line.strip().lstrip().rstrip(',').replace(' ', '')
        if is_contain(line, "=") or is_contain(line, "^"):
            # print ("读取到的内容：\n" + line)
            if line.startswith("path"):
                local_path = line.replace('path=', '').replace('"', '')
                print ('local_path: ' + local_path)
                print (".........")
            elif is_contain(line, '^'):
                split_line = line.split(':^')
                widget = split_line[0]
                version = split_line[1]
                print ('widget: ' + widget)
                print ('version: ' + version)
                update_widget(local_path, group, widget, version)


