#!/usr/bin/env python3

import subprocess
import unittest
import random

def generate_random_string(len):
    string = ''
    for i in range(len):
        string += chr(random.randrange(33, 128))
    return string

class TestCompiledCode(unittest.TestCase):
    def test_case1(self):
        for i in range(100000):
            len1 = random.randrange(1, 255)
            string1 = generate_random_string(len1)
            len2 = random.randrange(1, 255)
            string2 = generate_random_string(len2)
            choice = 31
            input_string = f'{len1}\n{string1}\n{len2}\n{string2}\n{choice}\n'.encode()
            
            expected_output = f"first pstring length: {len1}, second pstring length: {len2}\n"
            
            output = subprocess.run(['./a.out'], input=input_string, stdout=subprocess.PIPE).stdout.decode()
            try:
                self.assertEqual(output, expected_output)
            except:
                print(len1)
                print(string1)
                print(len2)
                print(string2)
                print(choice)
                print('\n\n\n')

                break;

    def test_case2(self):
        for i in range(100000):
            len1 = random.randrange(1, 255)
            string1 = generate_random_string(len1)
            len2 = random.randrange(1, 255)
            string2 = generate_random_string(len2)
            choice = 32
            char1 = chr(random.randrange(33, 128))
            char2 = chr(random.randrange(33, 128))
            input_string = f'{len1}\n{string1}\n{len2}\n{string2}\n{choice}\n{char1} {char2}'.encode()
            
            new_string1 = string1.replace(char1, char2)
            new_string2 = string2.replace(char1, char2)
            expected_output = f"old char: {char1}, new char: {char2}, first string: {new_string1}, second string: {new_string2}\n"
            
            output = subprocess.run(['./a.out'], input=input_string, stdout=subprocess.PIPE).stdout.decode()
            try:
                self.assertEqual(output, expected_output)
            except:
                print(len1)
                print(string1)
                print(len2)
                print(string2)
                print(choice)
                print(char1)
                print(char2)
                print('\n\n\n')

                
                break;
                

    def test_case3(self):
        for i in range(100000):
            len1 = random.randrange(1, 255)
            string1 = generate_random_string(len1)
            len2 = random.randrange(1, 255)
            string2 = generate_random_string(len2)
            choice = 35
            index1 = random.randrange(0, 255)
            index2 = random.randrange(0, 255)
            if index2 < index1:
                temp = index1
                index1 = index2
                index2 = temp
            input_string = f'{len1}\n{string1}\n{len2}\n{string2}\n{choice}\n{index1}\n{index2}'.encode()
            
            expected_output = ""
            if index2 >= len1:
                expected_output = "invalid input!\n"
            elif index2 >= len2:
                expected_output = "invalid input!\n"
            if expected_output == "":
                new_string1 = string1[0:index1]
                for i in range(index1, index2 + 1):
                    new_string1 += string2[i]
                new_string1 += string1[index2 + 1:]
            else:
                new_string1 = string1
                new_string2 = string2
            expected_output += f"length: {len1}, string: {new_string1}\nlength: {len2}, string: {string2}\n"
            
            output = subprocess.run(['./a.out'], input=input_string, stdout=subprocess.PIPE).stdout.decode()
            
            try:
                self.assertEqual(output, expected_output)
            except:
                print(len1)
                print(string1)
                print(len2)
                print(string2)
                print(choice)
                print(index1)
                print(index2)
                print('\n\n\n')

                
                break;
                

    def test_case4(self):
        for i in range(100000):
            len1 = random.randrange(1, 255)
            string1 = generate_random_string(len1)
            len2 = random.randrange(1, 255)
            string2 = generate_random_string(len2)
            choice = 36
            input_string = f'{len1}\n{string1}\n{len2}\n{string2}\n{choice}\n'.encode()
            
            new_string1 = string1.swapcase()
            new_string2 = string2.swapcase()
            expected_output = f"length: {len1}, string: {new_string1}\nlength: {len2}, string: {new_string2}\n"
            
            output = subprocess.run(['./a.out'], input=input_string, stdout=subprocess.PIPE).stdout.decode()
            try:
                self.assertEqual(output, expected_output)
            except:
                print(len1)
                print(string1)
                print(len2)
                print(string2)
                print(choice)
                print('\n\n\n')

                
                break;
                


    def test_case5(self):
        for i in range(100000):
            len1 = random.randrange(1, 255)
            string1 = generate_random_string(len1)
            len2 = random.randrange(1, 255)
            string2 = generate_random_string(len2)
            choice = 37
            index1 = random.randrange(0, 255)
            index2 = random.randrange(0, 255)
            if index2 < index1:
                temp = index1
                index1 = index2
                index2 = temp
            input_string = f'{len1}\n{string1}\n{len2}\n{string2}\n{choice}\n{index1}\n{index2}'.encode()
            
            result = None
            expected_output = ""
            if index2 >= len1:
                expected_output = "invalid input!\n"
                result = -2
            elif index2 >= len2:
                expected_output = "invalid input!\n"
                result = -2
            if result == None:
                if string1[index1:index2 + 1] > string2[index1:index2 + 1]:
                    result = 1
                elif string1[index1:index2 + 1] < string2[index1:index2 + 1]:
                    result = -1
                else:
                    result = 0
            expected_output += f"compare result: {result}\n"
            
            output = subprocess.run(['./a.out'], input=input_string, stdout=subprocess.PIPE).stdout.decode()
            try:
                self.assertEqual(output, expected_output)
            except:
                print(len1)
                print(string1)
                print(len2)
                print(string2)
                print(choice)
                print(index1)
                print(index2)
                print('\n\n\n')

                
                break;
                



if __name__ == '__main__':
    unittest.main()