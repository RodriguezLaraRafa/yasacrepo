import sys
import sys

operations_a = ["ADD", "MOV", "SUB", "LD", "ST", "CP", "AND", "OR", "EOR"]
operations_b = ["LDI", "LDS", "STS", "CPI", "JMP", "CALL"]
operations_c = ["BRBS", "BRBC"]
operations_d = ["RET", "STOP"]

def parse_line(index, line):

    usefulness = "useful"
    hex_index = hex(index).replace("0x", "")
    output_string = "code['h" + hex_index + "] = {" 

    parsed_line = line.replace("//", ";").strip(" ")

#######Debugging

#######Debugging

#De momento nos cargamos los comentarios
    output_string+=parsed_line[0:len(parsed_line)-2]
    output_string+="};\n"

    ##Ahora dependiendo del formato de la instruccion, hacemos una cosa u otra


    if(parsed_line[0]==";" or parsed_line[0]=="" or len(parsed_line.strip())<2):
        usefulness = "useless"
    return [output_string, usefulness]

def main():
    if len(sys.argv) >1:
        file_path = sys.argv[1]
        f = open(file_path, "r")
        #print(f.read())
        output = None
        try:
            output = open("output.code", "x")

        except:
            output = open("output.code", "w")

        index = 0

        for line in f:
            parsed_line = parse_line(index, line)
            if parsed_line[1] == "useful":
                output.write(parsed_line[0])
                index += 1



    else:
        print("Escribe el nombre del archivo a ensamblar..")

if __name__ == "__main__":
    main()