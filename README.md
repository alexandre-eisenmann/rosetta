## Rosetta ##

Very simple pure ruby program that recognises which language a given file was written.

The idea is identify the language using frequency analysis. Each natural language has a kind of
"frequency signature", so the set of frequencies of each letter characterizes a language. 
Per example, the most common letter in english is "e" followed by "t" and "a". This is not true
for other languages and is secure to say that all languages are different in that sense.

In order to capture the "language signature" for each language, the program will read the DATA 
folder to calculate the frequency profile for the provided languages. After that, it calculates 
the frequency of the input file as well. 

Finally, to determine which language is "closest" I defined the concept of "distance", which is similar to
a vectorial distance, but in this case the "vector" has 26 dimensions, one for each letter.

#Remarks:#

* A folder called DATA containing the sample languages MUST be located in the root of the project

* The program can recognize an unlimited number of languages as long as one or more samples of
this particular language were provided in the DATA folder. 

* The quality of recognition is proportional to the size of the file being verified. The longer,
the better. The reason is that very small files doesn't necessarily follow the statistical profile of 
the language. That being said, the program, surprisingly, was able to recognize the languages of really 
small files, containing just one phrase of 30 to 50 caracters


##Usage##

ruby rosetta.rb <filePath> => identify which language <filePath> was written
ruby rosetta.rb -runtests  => Run the tests
ruby rosetta.rb -usage     => show this options

#Example#

> ruby rosetta.rb TEXT.txt 
-------------------------------------------------------
TEXT.txt was written in ENGLISH
-------------------------------------------------------
