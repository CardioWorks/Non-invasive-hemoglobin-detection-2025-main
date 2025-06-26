# import os
# import ReadFile
# from sklearn import preprocessing
#
# path_data = './DATA/' 
# file_list = os.listdir(path_data) 
#
# for file_name in file_list:
#     if file_name.endswith('.mat'):
#         file_path = os.path.join(path_data, file_name)  
#         id = file_name.rstrip('.mat')  
#         id = int(''.join(filter(str.isdigit, id))) 
#         
#         ppgdata_1,ppgdata_2,ppgdata_3,ppgdata_4= ReadFile.Read_fourwave(file_path)
#         ppgdata_1 = preprocessing.scale(ppgdata_1)
#         ppgdata_2 = preprocessing.scale(ppgdata_2)
#         ppgdata_3 = preprocessing.scale(ppgdata_3)
#         ppgdata_4 = preprocessing.scale(ppgdata_4)
#
#         print(id)
#         print(file_path)

class User(object):
    def __init__(self, something):
        print("User lnit called.")
        self.something=something

    def method(self):
        return self.something

class Student(User):
    def __init__(self, something):
        User. __init__(self, something)
        print("Student Init called.")
        self.something# something

    def method(self):
        return self.something
my_object = Student('Jetty')