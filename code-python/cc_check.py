def cardLuhnChecksumIsValid(card_number):

    sum = 0
    num_digits = len(card_number)
    oddeven = num_digits & 1

    for count in range(0, num_digits):
        digit = int(card_number[count])

        if not (( count & 1 ) ^ oddeven):
            digit = digit * 2
        if digit > 9:
            digit = digit - 9

        sum = sum + digit

    return ((sum % 10) == 0)

x = input("Enter CC Number to verify: ")
print cardLuhnChecksumIsValid(str(x))
raw_input("\nPress Any Key...")
