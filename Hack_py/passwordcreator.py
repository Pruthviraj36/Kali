import random

fpwrite = open("wordlist1.txt", "a")
fpread = open("wordlist.txt", "r")

sum = 0

# sum = pass_of_lenght_six + pass_of_lenght_seven + pass_of_lenght_eight + pass_of_lenght_nine + pass_of_lenght_ten

pass_options = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*_+=-;:<>,."
pass_options_chars = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

fpread.read()

while sum <= 35000:
    if sum == 0 or sum <= 7000:
        pass_maker = random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options)

        password = str(pass_maker) + "\n"
        fpwrite.write(password)
        fpread.read()
        sum += 1
    elif sum <= 14000:
        pass_maker = random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars) + random.choice(seq=pass_options_chars)
        password = str(pass_maker) + "\n"
        fpwrite.write(password)
        fpread.read()
        sum += 1
    elif sum <= 21000:
        pass_maker = random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options)
        password = str(pass_maker) + "\n"
        fpwrite.write(password)
        fpread.read()
        sum += 1
    elif sum <= 28000:
        pass_maker = random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options)
        password = str(pass_maker) + "\n"
        fpwrite.write(password)
        fpread.read()
        sum += 1
    elif sum <= 35000:
        pass_maker = random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options) + random.choice(seq=pass_options)
        password = str(pass_maker) + "\n"
        fpwrite.write(password)
        fpread.read()
        sum += 1
    else:
        break


    # if sum > 200:
    #     break;

fpread.close()
fpwrite.close()