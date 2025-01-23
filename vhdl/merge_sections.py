#!/Users/tomp/bin/python
import re
import sys

def merge_sections(file1, file2, output_file):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        content1 = f1.readlines()
        content2 = f2.readlines()

    result = []
    section_map = {}

    # Parse sections from file2
    current_section = None
    for line in content2:
        match_start = re.match(r'-- New (\d+) start', line)
        match_end = re.match(r'-- New (\d+) end', line)

        if match_start:
            current_section = int(match_start.group(1))
            section_map[current_section] = []
        elif match_end:
            current_section = None
        elif current_section is not None:
            section_map[current_section].append(line)

    # Replace sections in file1
    current_section = None
    for line in content1:
        match_start = re.match(r'-- Replace (\d+) start', line)
        match_end = re.match(r'-- Replace (\d+) end', line)

        if match_start:
            current_section = int(match_start.group(1))
            result.append(line)  # Keep the start marker
            if current_section in section_map:
                result.extend(section_map[current_section])
        elif match_end:
            result.append(line)  # Keep the end marker
            current_section = None
        elif current_section is None:
            result.append(line)

    # Write the result to the output file
    with open(output_file, 'w') as out:
        out.writelines(result)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python merge_sections.py <file1> <file2> <output_file>")
        sys.exit(1)

    file1, file2, output_file = sys.argv[1], sys.argv[2], sys.argv[3]
    merge_sections(file1, file2, output_file)
    print(f"Merged sections written to {output_file}")
