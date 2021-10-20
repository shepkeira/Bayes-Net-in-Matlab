# Bayes-Net-in-Matlab
To run the code run main.m this will return the inference probability as a string.

## Code
Preprocessing is called by accuracy_averages (which returns the accuracy probabilities) and time_probability (which retuns the time probabilities).
The rest of the code can be found in main.m and is labled with comments

## Rational
Rational can also be found at the appropriate places in the code

Pr(NeedHelp|Easy) = 0.2
Pr(NeedHelp|Hard) = 0.6
The problems are not defined as hard or easy by the user so you may still need help with an easy question. But you will need more help with an hard question because they are designed to be more defficult. Since I can't see the question I used the accuracy and time to determine the help needed. The hard questions take much longer (about 5 times as long) but the accuracy is only slightly lower. For this reason I made the hard questions only slightly in favour of asking of needing help, and the easy questions strongly in favour of not needing help

Pr(Confused|NeedHelp=False) = 0.1
Pr(Confused|NeedHelp=True) = 0.75
If you do not need help, there is a possibility that you are still confused but are able to solve the problem still (via googling, re-reading the question, thinking more etc), however it is unlikely, most people who are confused would like help if it is avalible. If you do need help, it is likely you are confused, however you might also just have forgotten something, such as a formula, that you need to be reminded of. I think its more likely if you need help you are confused.
