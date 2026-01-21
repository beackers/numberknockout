## Number Knockout

The classic game. Players given three randomly rolled numbers compete to see who can find equations using all three numbers for the numbers 1-36 first.

I wrote these scripts after I decided I was a little slow on the head math, so I put the head math on silicon and made Lua crunch numbers for me.

### how to use

1. If you haven't got it already, install `lua`. If you've got Linux, that's available with  
`apt install lua54`  
or the newest version.[^1]
2. Clone the repo or download and extract a release:  
`git clone https://github.com/beackers/numberknockout --depth 1` [^2]
3. Run `knockout.lua` with the three numbers you rolled as the arguments, e.g.  
`lua knockout.lua 1 2 3`

If you have a crazy knockout (fun variations on the game imclude potentially rolling negative numbers, fractions or decimals, working numbers 1-72, or rolling four numbers instead of three), no worries! The script is happy to work with it.

**ALTHOUGH:** at the moment, the script only supports 3 numbers. It's due to the way permutations of parentheses work. With three numbers, there's two possible combinations of parentheses:
* (a b) c
* a (b c)

Adding more would require more complicated math than I can do at the moment. So cheers, enjoy, and work those extra numbers yourself ;)

Good luck and happy numbering. And don't forget to yell "BLACKOUT!" when you finish all 36! (Or 72.)

---

[^1]: Install instructions vary by OS and version.

[^2]: The "--depth 1" option is... well, optional, but it helps save space by not downloading the whole commit history for this repo.
