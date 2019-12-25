import re
import xlsxwriter

if __name__ == '__main__':
    listRow = []
    with open("src/donvi_ql" , encoding='utf8') as f:
        for line in f:
            line = line.strip()
            if line == r'<Row>':
                row = {}
            elif line == r'</Row>':
                listRow.append(row)
            elif re.match("<Cell",line):
                matchObj = re.search(r'<Cell name="(\w+)">(.*)</Cell>',line)
                row[matchObj.group(1)] = matchObj.group(2)

    print(listRow)

    workbook = xlsxwriter.Workbook('src/data.xlsx')
    worksheet = workbook.add_worksheet()
    rownum = 0
    col = 0
    for key in row.keys():
        worksheet.write(rownum, col, key)
        col += 1

    for row in listRow:
        col = 0
        rownum += 1
        for key in row.keys():
            worksheet.write(rownum, col, row[key])
            col = col + 1

    workbook.close()



