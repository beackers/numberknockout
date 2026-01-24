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

## limitations

If you have a crazy knockout (fun variations include more than three numbers, trying to reach 1-72, or using negatives), double check that this is going to meet requirements before you use it:
* Script only returns positive, integer numbers.
* Division only "works" when the result is a whole number.
* Using 7+ numbers for the input may crash your computer. For the latest info on how long it takes GitHub supercomputers to run it, check the `test` job in the Actions tab.

Good luck and happy numbering. And don't forget to yell "BLACKOUT!" when you finish all 36! (Or 72.)

---

[^1]: Install instructions vary by OS and version.

[^2]: The "--depth 1" option is... well, optional, but it helps save space by not downloading the whole commit history for this repo.
