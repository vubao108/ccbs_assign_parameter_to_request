import re
file1 = "src/thamso_chuyentinh_edit_thuebao"
file2 =  "src/thamso_chuyentinh_ghimoi"
if __name__ == '__main__':
    f1_list = [line.rstrip('\n').strip() for line in open(file1)]
    f2_list = [line.rstrip('\n').strip() for line in open(file2)]
    #dif_path = set(f1_list).symmetric_difference(set(f2_list))
    f1_list.sort()
    f2_list.sort()
    print("in edit now in new\n")
    for item in f1_list:
        if item not in f2_list:
            print(item + '\n')

    print("in new now in edit\n")
    for item in f2_list:
        if item not in f1_list:
            print(item + '\n')

