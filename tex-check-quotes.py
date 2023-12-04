#!/usr/bin/env python

import sys
import re

def check_latex_quotes(file_path):
    stack = []
    word_boundary_pattern = re.compile(r'\b')

    with open(file_path, 'r', encoding='utf-8') as file:
        for line_number, line in enumerate(file, start=1):
            ignore_quote = False
            for char_number, char in enumerate(line, start=1):
                if char == '%':
                    ignore_quote = True
                elif char in {'"', "'"} and not ignore_quote:
                    prev_char = line[char_number - 2] if char_number >= 2 else None
                    next_char = line[char_number] if char_number < len(line) else None

                    if (
                        (prev_char is None or not word_boundary_pattern.match(prev_char)) and
                        (next_char is None or not (next_char == 's' and char == "'"))
                    ):
                        if stack and stack[-1] == char:
                            stack.pop()
                        else:
                            stack.append((char, line_number, char_number))
                elif char == '\n':
                    ignore_quote = False

    for char, line_number, char_number in stack:
        print(f"Error: Unmatched {char} quote at line {line_number}, character {char_number}.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./latex_quote_checker.py <latex_file>")
        sys.exit(1)

    latex_file = sys.argv[1]
    check_latex_quotes(latex_file)
