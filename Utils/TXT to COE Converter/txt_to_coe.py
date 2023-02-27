from sys import argv

def main(args):
    if (len(args) == 0):
        print(f"Bruh! No args")

    arg_list = args.copy()
    arg_list.pop(0)
    memory_vector = []
    string0 = "memory_initialization_radix=10;"
    string1 = "memory_initialization_vector="
    for file in arg_list:
        try:
            with open(file, "r") as mem_file:
                print("Reading...")
                for line in mem_file:
                    format_line = line.rstrip("\n").rstrip(" ").split()
                    size = len(format_line)
                    if(size == 5):  # intrucoes que precisan de endereco
                        memory_vector.append(format_line[1])
                        memory_vector.append(format_line[2])
                        # print(f"Caso 1: {format_line[0]} - Instructions -> {format_line}")
                    elif(size == 3):  # instrucoes que n precisam de endereco
                        memory_vector.append(format_line[1])
                        # print(f"Caso 2: {format_line[0]} - Instructions -> {format_line}")
                    elif(size == 2):
                        memory_vector.append(format_line[1])
                        # print(f"Blank line -> {format_line}")
                    else:
                        continue  # invalid line
            for word in memory_vector:
                string1 += str(word) + ","

            string1 = string1[:-1]
            string1 += ";"

        except Exception as e:
            print(f"Bruh reading! -> {e}")
            return -1
        
        try:
            with open(file.split(".")[0] + ".coe", "w") as coe_file:
                print("Writting...")
                coe_file.write(string0)
                coe_file.write("\n")
                coe_file.write(string1)
                print(f"All done from file {file}!")
        except:
            print(f"Bruh writting! -> {e}")
            return -1
        memory_vector.clear()
        string1 = "memory_initialization_vector="
    print("All done - all files!")



if(__name__ == "__main__"):
    main(argv)