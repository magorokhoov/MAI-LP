dictionaryMyFamilyPerson = {}
listMyFamilyPerson = []
listAllFamily = []
listFinal = []

def CriateNullArray2D(numberOfLines, numberOfColumns):
    arr2D = []
    for i in range(numberOfLines):
        internulArr = []
        for j in range(numberOfColumns):
            internulArr.append(0)
        arr2D.append(internulArr)
    return arr2D

# создаем словарь
# id = имя /фамилия/
myTree = open('my_tree.ged', 'r')

for line in myTree:
    if line[2:4] == "@I":
        listMyFamilyPerson.append(int(line[5:10]))
    if line[0:6] == "1 NAME":
        listMyFamilyPerson.append(line[7:-1])
    if line[0:5] == "1 SEX":
        listMyFamilyPerson.append(line[6:-1])

myTree.close()

str_tmp = ""
for i in range(1, len(listMyFamilyPerson), 3):
    str_tmp = '\'' + listMyFamilyPerson[i].replace('/', '') + '\''
    listMyFamilyPerson[i] = str_tmp
    print(listMyFamilyPerson[i])

print()

for line in range(0, len(listMyFamilyPerson), 3):
    dictionaryMyFamilyPerson[listMyFamilyPerson[line]] = listMyFamilyPerson[line+1]
print(dictionaryMyFamilyPerson)
# словарь создан!

listAllFamily = CriateNullArray2D(len(dictionaryMyFamilyPerson), 2)

myTree = open('my_tree.ged', 'r')
i = -1
for line in myTree:
    if line[2:4] == "@F":
        i += 1
    if line[0:6] == "1 HUSB":
        listAllFamily[i][0] = int(line[10:15])
    if line[0:6] == "1 WIFE":
        listAllFamily[i][1] = int(line[10:15])
    if line[0:6] == "1 CHIL":
        listAllFamily[i].append(int(line[10:15]))

myTree.close()

print(listAllFamily)

listFinal = CriateNullArray2D(len(dictionaryMyFamilyPerson), 3)
k = 0

for i in range(len(listAllFamily)):
    if listAllFamily[i] == [0, 0]:
        break
    for j in range(len(listAllFamily[i]) - 2):
        listFinal[k][0] = listAllFamily[i].pop(-1)
        listFinal[k][1] = listAllFamily[i][0]
        listFinal[k][2] = listAllFamily[i][1]
        k += 1

fileForWrite = open('perients.txt', 'w')
i = 0
while listFinal[i] != [0, 0, 0]:
    fileForWrite.write("parents( " + dictionaryMyFamilyPerson[listFinal[i][0]] + ", " +
                      dictionaryMyFamilyPerson[listFinal[i][1]] + ", " +
                      dictionaryMyFamilyPerson[listFinal[i][2]] + " )." + "\n")
    i += 1

for k in range(2, len(listMyFamilyPerson), 3):
    if listMyFamilyPerson[k] == 'M':
        fileForWrite.write("male( " + listMyFamilyPerson[k-1] + " )." + "\n")
    else:
        fileForWrite.write("female( " + listMyFamilyPerson[k-1] + " )." + "\n")
fileForWrite.close()
