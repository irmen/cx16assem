import string
import random
import matplotlib.pyplot as plt
import seaborn as sns


def process_word(w):
    w = w.rstrip()
    w2 = [char for char in w if char in string.ascii_letters]
    return "".join(w2).upper()

raw_words = random.sample(open("/usr/share/dict/words", "rt").readlines(), 100)
words = [pw for pw in [process_word(w) for w in raw_words] if pw]


def create_labelname(idx):
    w1 = random.choice(words)
    w2 = "" # random.choice(words)
    name = (w1+w2)[:25].upper()
    return name + "." + str(idx) + random.choice(string.ascii_uppercase+string.digits)


number_of_labels = 5000
labels = [create_labelname(idx) for idx in range(number_of_labels)]


def hashfunc1(label):
    length = len(label)  # assume we know the length of the symbol already
    c0 = ord(label[0])
    c1 = ord(label[1])
    clast = ord(label[length-1])
    return ((c0 + clast + c1*4) ^ (length*4)) & 127


def hashfunc2(label):
    # just sum up all the characters of the label....
    # could be faster / better if you have to scan it anyway to determine the length
    # also seems to work better for shorter labels
    length=len(label)
    return (sum([ord(c) for c in label]) ^ (length*2)) & 127

def hashfunc3(label):
    # this is the  string.hash  function in the prog8 string library
    hashcode = 179
    carry = 0
    for c in label:
        newcarry = 1 if hashcode&128 else 0
        hashcode = (hashcode << 1) & 255 | carry
        carry = newcarry
        hashcode ^= ord(c)
    return hashcode


if __name__=="__main__":
    hash_buckets = [0] * 128
    for lbl in labels:
        hashvalue = hashfunc1(lbl)
        hash_buckets[hashvalue] += 1
    plt.subplots(figsize = (20,5))
    p=sns.barplot(x=list(range(len(hash_buckets))), y=hash_buckets)
    plt.show()

    hash_buckets = [0] * 128
    for lbl in labels:
        hashvalue = hashfunc2(lbl)
        hash_buckets[hashvalue] += 1
    plt.subplots(figsize = (20,5))
    sns.barplot(x=list(range(len(hash_buckets))), y=hash_buckets)
    plt.show()

    hash_buckets = [0] * 256
    for lbl in labels:
        hashvalue = hashfunc3(lbl)
        hash_buckets[hashvalue] += 1
    plt.subplots(figsize = (20,5))
    sns.barplot(x=list(range(len(hash_buckets))), y=hash_buckets)
    plt.show()
