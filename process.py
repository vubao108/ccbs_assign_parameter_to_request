import re
body_request = "src/body_request"
parameter_value = "src/parameter_value"
result = "src/result"

def assign_parameter():
    dict_parameter = {}
    result_file = open(result,encoding='utf8',mode='w')
    with open(body_request) as f:
        for line in f:
            line = line.strip()
            matchObj =  re.match(r"<(\w+)>string</\w+>$",line)
            if line and matchObj:
                dict_parameter[matchObj.group(1)] = ""

    with open(parameter_value,encoding='utf8') as f:
        for line in f:
            line = line.strip()
            if re.match(r"\w+Field",line):
                continue
            elif line and re.match(r"\w+",line):
                parameter = re.match(r"(\w+)",line).group(1)
                value = re.search(r"^\w+\s+(.+)\s+string$",line).group(1)
                if value == "null":
                    value = ""
                else:
                    value = value.replace('"','')

                print (parameter + " : " + value)
                if(parameter in dict_parameter.keys()):
                    dict_parameter[parameter] = value
    for key in dict_parameter.keys():
        result_file.write("\t<{}>{}</{}>\n".format(key, dict_parameter[key], key))


    result_file.close()







if __name__ == '__main__':
    f_huongdan = open("src/huongdan",encoding='utf8')
    print(f_huongdan.read())
    #input("Nhap du lieu nhu huong dan va an Enter de xu ly :")
    assign_parameter()
    #input("Xong . Nhan Ok de thoat ")
