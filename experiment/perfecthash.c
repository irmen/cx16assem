/* ANSI-C code produced by gperf version 3.1 */
/* Command-line: gperf --no-strlen --null-strings -7 -C -D -E -m 100  */
/* Computed positions: -k'1-3,$' */

#if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
      && ('%' == 37) && ('&' == 38) && ('\'' == 39) && ('(' == 40) \
      && (')' == 41) && ('*' == 42) && ('+' == 43) && (',' == 44) \
      && ('-' == 45) && ('.' == 46) && ('/' == 47) && ('0' == 48) \
      && ('1' == 49) && ('2' == 50) && ('3' == 51) && ('4' == 52) \
      && ('5' == 53) && ('6' == 54) && ('7' == 55) && ('8' == 56) \
      && ('9' == 57) && (':' == 58) && (';' == 59) && ('<' == 60) \
      && ('=' == 61) && ('>' == 62) && ('?' == 63) && ('A' == 65) \
      && ('B' == 66) && ('C' == 67) && ('D' == 68) && ('E' == 69) \
      && ('F' == 70) && ('G' == 71) && ('H' == 72) && ('I' == 73) \
      && ('J' == 74) && ('K' == 75) && ('L' == 76) && ('M' == 77) \
      && ('N' == 78) && ('O' == 79) && ('P' == 80) && ('Q' == 81) \
      && ('R' == 82) && ('S' == 83) && ('T' == 84) && ('U' == 85) \
      && ('V' == 86) && ('W' == 87) && ('X' == 88) && ('Y' == 89) \
      && ('Z' == 90) && ('[' == 91) && ('\\' == 92) && (']' == 93) \
      && ('^' == 94) && ('_' == 95) && ('a' == 97) && ('b' == 98) \
      && ('c' == 99) && ('d' == 100) && ('e' == 101) && ('f' == 102) \
      && ('g' == 103) && ('h' == 104) && ('i' == 105) && ('j' == 106) \
      && ('k' == 107) && ('l' == 108) && ('m' == 109) && ('n' == 110) \
      && ('o' == 111) && ('p' == 112) && ('q' == 113) && ('r' == 114) \
      && ('s' == 115) && ('t' == 116) && ('u' == 117) && ('v' == 118) \
      && ('w' == 119) && ('x' == 120) && ('y' == 121) && ('z' == 122) \
      && ('{' == 123) && ('|' == 124) && ('}' == 125) && ('~' == 126))
/* The character set is not based on ISO-646.  */
#error "gperf generated tables don't work with this execution character set. Please report a bug to <bug-gperf@gnu.org>."
#endif

/* maximum key range = 125, duplicates = 0 */

#ifdef __GNUC__
__inline
#else
#ifdef __cplusplus
inline
#endif
#endif
static unsigned int
hash (register const char *str, register size_t len)
{
  static const unsigned char asso_values[] =
    {
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126,  73,  66,
       61,  59,  56,  49,  47,  30, 126, 126, 126, 126,
      126, 126, 126, 126, 126,  10,   3,  13,  23,   9,
       25, 126, 126,   1,  90,   7,  12,  22,  35,  23,
        0,  28,   1,   0,   4,   4,  12,  88,   6,   4,
       33, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126, 126,
      126, 126, 126, 126, 126, 126, 126, 126, 126
    };
  return asso_values[(unsigned char)str[2]] + asso_values[(unsigned char)str[1]+1] + asso_values[(unsigned char)str[0]] + asso_values[(unsigned char)str[len - 1]];
}

const char *
in_word_set (register const char *str, register size_t len)
{
  enum
    {
      TOTAL_KEYWORDS = 98,
      MIN_WORD_LENGTH = 3,
      MAX_WORD_LENGTH = 4,
      MIN_HASH_VALUE = 1,
      MAX_HASH_VALUE = 125
    };

  static const char * const wordlist[] =
    {
      "PHP",
      "ROR",
      "STP",
      "RTS",
      "RTI",
      "TXS",
      "PHY",
      "TRB",
      "EOR",
      "STY",
      "PHX",
      "TSB",
      "TAY",
      "STX",
      "BRK",
      "LSR",
      "TAX",
      "TSX",
      "PHA",
      "PLP",
      "BRA",
      "STA",
      "ROL",
      "BCS",
      "SEI",
      "TXA",
      "LDY",
      "PLY",
      "INY",
      "LDX",
      "PLX",
      "NOP",
      "INX",
      "CLI",
      "ASL",
      "SBC",
      "BMI",
      "LDA",
      "PLA",
      "ORA",
      "BNE",
      "ADC",
      "BBS7",
      "BBR7",
      "CMP",
      "CPY",
      "INC",
      "SEC",
      "BCC",
      "CPX",
      "BPL",
      "DEY",
      "TYA",
      "CLV",
      "DEX",
      "CLC",
      "BBS6",
      "BBR6",
      "BBS5",
      "BBR5",
      "SMB7",
      "RMB7",
      "STZ",
      "SED",
      "BBS4",
      "BBR4",
      "DEC",
      "BBS3",
      "BBR3",
      "BBS2",
      "BBR2",
      "AND",
      "CLD",
      "BBS1",
      "BBR1",
      "BEQ",
      "SMB6",
      "RMB6",
      "SMB5",
      "RMB5",
      "BBS0",
      "BBR0",
      "BVS",
      "WAI",
      "SMB4",
      "RMB4",
      "JSR",
      "SMB3",
      "RMB3",
      "SMB2",
      "RMB2",
      "BIT",
      "SMB1",
      "RMB1",
      "SMB0",
      "RMB0",
      "BVC",
      "JMP"
    };

  static const signed char lookup[] =
    {
      -1,  0, -1,  1,  2,  3, -1,  4,  5,  6,  7,  8,  9, 10,
      11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
      25, 26, 27, -1, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
      38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, -1, 50,
      51, 52, -1, 53, 54, 55, -1, 56, 57, 58, 59, -1, 60, 61,
      62, 63, 64, 65, 66, 67, 68, 69, 70, 71, -1, 72, 73, 74,
      75, 76, 77, 78, 79, 80, 81, 82, -1, 83, 84, 85, 86, 87,
      88, 89, 90, 91, -1, -1, 92, 93, -1, -1, -1, -1, -1, 94,
      95, -1, -1, -1, -1, 96, -1, -1, -1, -1, -1, -1, -1, 97
    };

  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register unsigned int key = hash (str, len);

      if (key <= MAX_HASH_VALUE)
        {
          register int index = lookup[key];

          if (index >= 0)
            {
              register const char *s = wordlist[index];

              if (*str == *s && !strcmp (str + 1, s + 1))
                return s;
            }
        }
    }
  return 0;
}
