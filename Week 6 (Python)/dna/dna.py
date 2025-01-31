import csv
import sys
from sys import argv

def main():

    if len(argv) != 3:
        sys.exit(1)
    if not argv[1].endswith(".csv"):
        sys.exit(1)
    if not argv[2].endswith(".txt"):
        sys.exit(1)

    rows = []
    with open(argv[1]) as file:
        reader = csv.DictReader(file)
        fieldnames = reader.fieldnames
        for row in reader:
            for key in row:
                if key != "name":
                    row[key] = int(row[key])
            rows.append(row)


    with open(argv[2]) as f:
        dna_sequence = f.read()

    # TODO: Find longest match of each STR in DNA sequence

    longestMatch = {}
                                    # .fieldnames are headers, like 'name', 'AGAT', 'AATG', 'TATC'
    for str_name in fieldnames[1:]:    # skips the "name" column
        longestMatch[str_name] = longest_match(dna_sequence, str_name)

    # TODO: Check database for matching profiles

    for row in rows:
        match = True
        for str_name in longestMatch:
            if int(row[str_name]) != longestMatch[str_name]:
                match = False
                break
        if match:
            print(row["name"])
            return
    else:
        print("No match")

    return

def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):

        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:

            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match  in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
