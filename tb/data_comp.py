from os.path import exists
import os
import sys;

def convert_to_binary(input_file : str, output_file : str = None):
    """
    Reads decimal numbers from a txt file, converts them to binary,
    and writes the binary representations to a new txt file.
    """
    if output_file is None:
        # Extract filename without path and put output in src/memory/
        output_file = input_file.split('/')[-1].rsplit('.', 1)[0] + '_binary.txt'
        output_folder = f'src/memory'
        if not exists(output_folder):
            os.makedirs(output_folder, exist_ok=True)
        output_file = os.path.join(output_folder, output_file)

    try:
        with open(input_file, 'r') as f:
            lines = f.readlines()

        binary_lines = []
        for line in lines:
            line = line.strip()
            if line:  # Skip empty lines
                try:
                    decimal_num = int(line)
                    # Remove '0b' prefix from binary representation and pad to 32 bits
                    binary_str = bin(decimal_num)[2:].zfill(32)
                    binary_lines.append(binary_str)
                except ValueError:
                    print(f"Warning: '{line}' is not a valid decimal number, skipping...")

        # Write binary numbers to output file
        with open(output_file, 'w') as f:
            for binary_line in binary_lines:
                f.write(binary_line + '\n')

        print(f"Successfully converted {len(binary_lines)} numbers from {input_file} to {output_file}")

    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python compiler_data.py <input_txt_file> [output_txt_file]")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    convert_to_binary(input_file, output_file)