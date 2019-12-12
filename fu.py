# coding=utf-8
import os
import shutil
import requests
import zipfile

base_url = 'http://gitlab.alibaba-inc.com/{group}/{widget}/repository/archive.zip?ref={version}'

# text是否包含content
def is_contain(text, content):
    if text.find(content) != -1:
        return True
    else:
        return False


def is_empty(s):
    return len(s) == 0

def runCmd(cmd):
    print (cmd)
    f = os.popen(cmd)
    text = f.read()
    f.close()
    return text

def update_widget(local_path, group, widget, version):
    url = base_url.format(group=group, widget=widget, version=version)
    print (widget + " 组件地址：" + url)
    response = requests.get(url)
    zipfile_name = widget + ".zip"
    with open(zipfile_name, "wb") as code:
        code.write(response.content)
        try:
            shutil.rmtree(local_path + widget)
        except IOError:
            print("清理老版本 " + widget + " 组件失败！可能的原因是，此前尚未引入该组件.")
        else:
            print("清理老版本 " + widget + " 组件成功！")
        with zipfile.ZipFile(zipfile_name, 'r') as zip:
            temp_file = "temp_" + widget
            zip.extractall(temp_file)
            for file in zip.namelist():
                print (file)
                if file.endswith(zip.namelist()[0] + "lib/"):
                    if not local_path.endswith("/"):
                        local_path = local_path + "/"
                    shutil.move(temp_file + "/" + file, local_path + widget)
                    print (widget + " 组件更新成功!")
                    break
            os.unlink(widget + ".zip")
            shutil.rmtree(temp_file)
            print ("清理 " + widget + " 组件临时文件完成!")
            print ("-----------")
            runCmd("git add " + (local_path + widget))

local_path = "/lib/widget/"
group = 'fapi'
widget = 'button'
version = "0.0.1"

with open("flutter_ui.txt", "r") as file:
    for line in file:
        line = line.strip().lstrip().rstrip(',').replace(' ', '')
        if is_contain(line, "=") or is_contain(line, "^"):
            # print ("读取到的内容：\n" + line)
            if line.startswith("path"):
                local_path = line.replace('path=', '').replace('"', '')
                print ('local_path: ' + local_path)
                print (".........")
            elif line.startswith("group"):
                group = line.replace('group=', '').replace('"', '')
                print ('group: ' + group)
                print (".........")
            elif is_contain(line, '^'):
                split_line = line.split(':^')
                widget = split_line[0]
                version = split_line[1]
                print ('widget: ' + widget)
                print ('version: ' + version)
                update_widget(local_path, group, widget, version)


