#!/usr/bin/env python

import sys
import re

def find_labels_and_references(tex_content):
    # Function to find all labels and references in the LaTeX content
    labels = re.findall(r'\\label{([^}]+)}(?![^\n]*%.*\\label{[^}]+})', tex_content)
    # Match labels that are not within commented sections
    references = re.findall(r'\\ref{([^}]+)}', tex_content)
    # Return sets of labels and references
    return set(labels), set(references)

def check_references(tex_content):
    # Function to check unreferenced labels and undefined references
    labels, references = find_labels_and_references(tex_content)
    # Labels without corresponding references
    unreferenced_labels = labels - references
    # References to labels that do not exist
    undefined_references = references - labels
    # Return sets of unreferenced labels and undefined references
    return unreferenced_labels, undefined_references

def main():
    # Check if the correct number of command-line arguments is provided
    if len(sys.argv) != 2:
        print("Usage: ./script_name.py your_tex_file.tex")
        sys.exit(1)

    # Get the file path from the command-line argument
    tex_file_path = sys.argv[1]

    try:
        # Open the .tex file and read its content
        with open(tex_file_path, 'r', encoding='utf-8') as tex_file:
            tex_content = tex_file.read()
            # Check for unreferenced labels and undefined references
            unreferenced_labels, undefined_references = check_references(tex_content)

            # Display the results
            if not unreferenced_labels and not undefined_references:
                print("All labels are referenced at least once, and all references are defined.")
            else:
                if unreferenced_labels:
                    print("Unreferenced labels found:")
                    for label in unreferenced_labels:
                        print(f" - {label}")

                if undefined_references:
                    print("References to undefined labels found:")
                    for reference in undefined_references:
                        print(f" - {reference}")

    except FileNotFoundError:
        print(f"Error: File not found at {tex_file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    # Execute the main function when the script is run
    main()
