#######################################
#
# OKO 19.05.2020 Generator for random derivation chains in the MIU system.
#                For the MIU system and the MU puzzle, see Hofstadter´s book "Gödel, Escher, Bach".
#
# OKO 07.06.2020 Revised for publishing it on Github.
#                - all naming in English
#                - program arguments indroduced
#
# Usage:
# awk -f mu-puzzle.awk [<options>]  //e.g. awk -f mu-puzzle.awk s12 x100
# awk -f mu-puzzle.awk help         //to get help
#
#######################################
BEGIN {
	MAX_WORD_SIZE = 120; # words are shown abbreviated from this size on
	NUM_STEPS = 8; # number of steps

	# evaluate command line options
	interpretArgument(ARGV[1]);
	interpretArgument(ARGV[2]);

	srand(); # thus, the same random numbers do not always come up

	print "output line: <step>. r<rule>[(<position>)] word";
	word = "MI";
	print "0. " word;

	for (step = 1; step <= NUM_STEPS; step++) {
		rules = getApplicableRules(word);
		rule = substr(rules, randInt(length(rules)), 1);
		pos = 0
		hasVariants = 0

		if (rule == 1) {
			word = applyRuleOne(word);
		} else if (rule == 2) {
			word = applyRuleTwo(word);
		} else if (rule == 3 || rule == 4) {
			strPositions = getPositionsOfSubstring(word, rule == 3 ? "III" : "UU"); # positions as string
			split(strPositions, arrPositions, ",") #Positionen als Array
			hasVariants = (length(arrPositions) > 1)
			pos = arrPositions[randInt(length(arrPositions))]
			word = rule == 3 ? applyRuleThree(word, pos) : applyRuleFour(word, pos);
		}

		printf("%d. r%d%s %s\n", step, rule, hasVariants?"("pos")":"", abbreviate(word, MAX_WORD_SIZE));

		if (word == "MU") break; # this will never be true ;-)
	}
}

function interpretArgument(arg) {
	if (arg == "help") {
		showHelp();
		exit;
	}
	if (arg ~ /s[0-9]+/) {
		NUM_STEPS = strtonum(substr(arg, 2));
	}
	if (arg ~ /x[0-9]+/) {
		MAX_WORD_SIZE = strtonum(substr(arg, 2));
	}
}

function showHelp() {
	print ""
	print "PURPOSE: Generates a random derivation chain in the MIU system, starting with \"MI\"."
	print ""
	print "USAGE:   awk -f mu-puzzle.awk [<options>]"
	print "         awk -f mu-puzzle.awk help"
	print ""
	print "OPTIONS: s<num>    number of steps, i.e. length of the derivation chain"
	print "         x<len>    If derived word exceeds this length, it will be displayed abbreviated."
	print ""
	print "EXAMPLE: awk -f mu-puzzle.awk s12 x100"
	print ""
	print "OUTPUT FORMAT: <step>. r<rule>[(<pos>)] <word>"
	print ""
	print "               step   number of current step"
	print "               rule   number of applied rule"
	print "               pos    position of substitution when application of rule is ambiguous"
	print "               word   derived word"
	print ""
}

#---------------------------------------------------------------
# Returns all positions of substring within the word.
# Result is a comma separated list as string! e.g. "3,12" means: substring at position 3 and 12.
#---------------------------------------------------------------
function getPositionsOfSubstring(word, substring) {
	# ASSUMPTION: word contains substring at least once!
	pos1 = index(word, substring) # first position
	positions = pos1;
	lenSubstr = length(substring)
	stop = length(word) - lenSubstr + 1

	# determine further positions
	for (i = pos1 + 1; i <= stop; i++) {
		if (substr(word, i, lenSubstr) == substring)
			positions = positions "," i
	}

	return positions;
}

#---------------------------------------------------------------
# Returns all rules that are applicable to word.
# Result is a string! e.g. "13" means: rule #1 and #3 are applicable.
#---------------------------------------------------------------
function getApplicableRules(word) {
	rules = ""
	if (isRuleOneApplicable(word))
		rules = rules "1";
	if (isRuleTwoApplicable(word))
		rules = rules "2";
	if (isRuleThreeApplicable(word))
		rules = rules "3";
	if (isRuleFourApplicable(word))
		rules = rules "4";
	return rules;
}

# Returns random integer between 1 and n.
function randInt(n) {
	return int(rand() * n) + 1;
}

# Is transformation rule #1 applicable to word?
function isRuleOneApplicable(word) {
	return word ~ /I$/;
}

# Is transformation rule #2 applicable to word?
function isRuleTwoApplicable(word) {
	return word ~ /^M.+/;
}

# Is transformation rule #3 applicable to word?
function isRuleThreeApplicable(word) {
	return word ~ /III/;
}

# Is transformation rule #4 applicable to word?
function isRuleFourApplicable(word) {
	return word ~ /UU/;
}

# Applies transformation rule #1 to word and returns a new word by appending a "U".
# xI -> xIU
function applyRuleOne(word) {
	return word "U";
}

# Applies transformation rule #2 to word and returns a new word by dublication.
# rule: Mx -> Mxx
function applyRuleTwo(word) {
	return "M" substr(word, 2) substr(word, 2);
}

# Applies transformation rule #3 to word and returns a new word by substitution at position pos.
# rule: xIIIy -> xUy
#        ^pos
function applyRuleThree(word, pos) {
	return substr(word, 1, pos-1) "U" substr(word, pos+3);
}

# Applies transformation rule #4 to word and returns a new word by substitution at position pos.
# rule: xUUy -> xy
#        ^pos
function applyRuleFour(word, pos) {
	return substr(word, 1, pos-1) substr(word, pos+2);
}

# Abbreviates text by omitting the middle section when maxLength is exceeded.
function abbreviate(text, maxLength) {
	origLen = length(text)

	if (origLen <= maxLength) {
		return text;
	} else {
		l = maxLength - 3; #"..." is 3 in length; you must subtract that
		l1 = int((l + 1) / 2);
		l2 = int(l / 2);

		return substr(text, 1, l1)"..."substr(text, origLen - l2 + 1)" ("origLen" chars)"
	}
}
