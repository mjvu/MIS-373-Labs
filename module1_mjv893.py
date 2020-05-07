def beesnees():
    print ''
    print 'BEESNEES FUNCTION'
    for i in range(1, 101):
        if i%3 == 0 and i%5 == 0:
            print 'BEESNEES',
        elif i%3 == 0:
            print 'Bees',
        elif i%5 == 0:
            print 'Nees',
        else:
            print i,

def factorial():
    print 'FACTORIAL FUNCTION'
    running = True

    while running: 
        try:
            n = int(raw_input('Factorial: Please enter a positive integer: '))
            if n < 0:
                print 'This is NOT a positive integer. Please try again.'
                print ''
                continue
            elif n > 0:
                factorial = 1
                for i in range(1, n+1):
                    factorial = factorial * i
                print '%s! is %s'% (n, factorial)
                running = False  
            break
        except ValueError:
            print 'That is NOT an integer. Please try again'
            print ''
            continue

def fibonacci():
    print 'FIBONACCI FUNCTION'
    running = True

    while running: 
        try:
            n = int(raw_input('Fibonacci: Please enter a positive integer: '))
            n1 = 0
            n2 = 1
            count = 0
            if n < 0:
                print 'This is NOT a positive integer. Please try again.'
                print ''
                continue
            elif n > 0:
                while count < n:
                    print '%s   '% (n1),
                    nth = n1 + n2
                    n1 = n2
                    n2 = nth
                    count += 1
                running = False 
            break
        except ValueError:
            print 'That is NOT an integer. Please try again'
            print ''
            continue

def pyramid():
    print 'PYRAMID FUNCTION'
    running = True

    while running: 
        try:
            n = int(raw_input('Pyramid: Please enter a positive integer: '))

            if n < 0:
                print 'This is NOT a positive integer. Please try again.'
                print ''
                continue
            elif n > 0:
                k = (1*n) - 1
                for i in range(0, n):
                    for j in range(0, k):
                        print '',
                    k = k - 1
                    for j in range(0, i+1):
                        print '* ',
                    print''
                running = False
            break
        except ValueError:
            print 'That is NOT an integer. Please try again'
            print ''
            continue

def towercash():
    print 'TOWERCASH FUNCTION'
    tower = 94.0
    dollar = 0.00011
    height = 0
    day = 1

    print '%-15s %-15s'% ('DAYS', 'HEIGHT (in meters)')
    print '%-15s %-15s'% (day, dollar)

    while True:
        day += 1
        dollar *= 2
        height += dollar
        print '%-15s %-15s'% (day, height)

        if height >= tower:
            break

def wordcount():
    print 'WORDCOUNT FUNCTION'
    wordString = 'the cat sat on the wall and the cat sat on the mat where the rat usually sat and the cat sat on the rat'
    wordList = wordString.split()

    wordDict = {}
    for word in wordList:
        wordDict[word] = wordList.count(word)
        
    wordSort = [(wordDict[key], key) for key in wordDict]
    wordSort.sort(reverse = True)
    print wordString
    print ''
    print 'Here are the word counts for each word in the above sentence:'
    for s in wordSort: print str(s)

def cipher():
    print 'CIPHER FUNCTION'
    alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
    cipher = 'GnWkmEJIRQsHLzPSdqVoxfrZbTyOBXhNiwCDcupUYMKgAjlavtFe'
    alphabetList = list(alphabet)
    cipherList = list(cipher)

    cipherListIndex = []
    for x in cipherList:
        cipherListIndex.append(cipherList.index(x))
        
    alphabetListIndex = []
    for x in alphabetList:
        alphabetListIndex.append(alphabetList.index(x))

    message = raw_input('Enter a message: ')

    while True:
        if message == 'x' or message == 'X':
            break
        elif message.startswith('1') == True:
            message = message[1:]
            messageList = list(message)

            index = []
            for x in messageList:
                for y in cipherList:
                    if x == y:
                        index.append(cipherList.index(y))

            output = []
            for x in index:
                for y in alphabetListIndex:
                    if x == y:
                        output.append(alphabetList[x])

            decodedMessage = ''.join(output)
            
            print 'The decoded message is: %s'% (decodedMessage)
            print ''
            message = raw_input('Enter a message: ')
        else:
            messageList = list(message)

            index = []
            for x in messageList:
                for y in alphabetList:
                    if x == y:
                        index.append(alphabetList.index(y))

            output = []
            for x in index:
                for y in cipherListIndex:
                    if x == y:
                        output.append(cipherList[x])

            encodedMessage = ''.join(output)
            
            print 'The encoded message is: %s'% (encodedMessage)
            print ''
            message = raw_input('Enter a message: ')

def indexer():
    print 'INDEXER FUNCTION'
    wordList = ['the', 'cat', 'sat', 'on', 'the', 'wall', 'and', 'the', 'cat', 'sat', 'on', 'the', 'mat', 'where', 'the', 'rat', 'usually', 'sat', 'and', 'the', 'cat', 'sat', 'on', 'the', 'rat']
    print wordList
    print ''

    word = raw_input('Please enter a word from the list above to receive its position: ').lower()
    indexPosList = []
    indexPos = 0
    while True:
        try:
            indexPos = wordList.index(word, indexPos)
            indexPosList.append(indexPos)
            indexPos += 1
        except ValueError as e:
            break
    print indexPosList

def hangman():
    print 'HANGMAN FUNCTION'
    import random

    running = True
    play = True
    wordBank = ['purchasing', 'snake', 'venom', 'makes', 'savagery', 'attainable']
    usedWords = []

    while running:
        word = random.choice(wordBank)
        wordBank.remove(word)
        usedWords.append(word)
        
        turns = len(word) + 3
        guesses = ''
        
        while play:
            if turns == 0:
                print 'You lose!'
                break
            
            failed = 0
            for char in word:
                if char in guesses:
                    print char,
                else:
                    print '-',
                    failed += 1
                
            if failed == 0:
                print ''
                print 'You won! You guessed the word %s'% (word)
                break
            
            print ''        
            guess = raw_input('Guess a letter: ').lower()
            print ''

            guesses += guess
            if guess not in word:
                print 'That letter does not exist'

            turns -= 1
            print 'You have %s turns left!'% (turns)
            
        restart = raw_input('Do you want to play again? ').lower()
        print '*' * 40
        print ''
        
        if restart == 'yes':
            play = True
            if len(wordBank) == 0:
                wordBank = ['purchasing', 'snake', 'venom', 'makes', 'savagery', 'attainable']
                usedWords[:] = []
        else:
            running = False

def palindrome():
    print 'PALINDROME FUNCTION'
    word = raw_input('Enter a word: ').lower()
    checkWord = ''

    for i in word:
        checkWord = i + checkWord
    if word == checkWord:
        print 'Your word is a palindrome'
    else: 
        print 'Your word is NOT a palindrome'


def odometer():
    print 'ODOMETER FUNCTION'
    print 'The possible odometer values are:'
    for i in range(100000, 1000000):
        if str(i)[2:6] == str(i)[6:1:-1]:
            i += 1
            if str(i)[1:6] == str(i)[5:0:-1]:
                i += 1
                if str(i)[1:5] == str(i)[-2:0:-1]:
                    i += 1
                    if str(i) == str(i)[::-1]:
                        print i - 3

beesnees()
print '\n'
print '*' * 100
factorial()
print '\n'
print '*' * 100
fibonacci()
print '\n'
print '*' * 100
pyramid()
print '\n'
print '*' * 100
towercash()
print '\n'
print '*' * 100
wordcount()
print '\n'
print '*' * 100
cipher()
print '\n'
print '*' * 100
indexer()
print '\n'
print '*' * 100
hangman()
print '\n'
print '*' * 100
palindrome()
print '\n'
print '*' * 100
odometer()
