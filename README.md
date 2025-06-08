# git-mega-rrfs
This is a customized (some kind of simplified) version of [`git-mega`](https://github.com/git-mega/git-mega) for the Level 2 management of the RRFS2 fix files (`FIX_RRFS2`).

Only those who have been contacted will need to learn and understand how to use this version of `git-mega`

# 1. How to use `git-mega` to do real tracking of `FIX_RRFS2`?
### NOTE:
- *Generally, we can only **add** fix files into `FIX_RRFS2` (i.e. no overwrite, no removal)*  
- *If there is a need to remove some binary files, it should be done and coordinated in a group work meeting with a majority of the fix file managers present*
- *Before git add fix files into the `FIX_RRFS` repo, be sure to check the file size first. Sometimes, an unexpected file size may indicate unresolved issues. It is easy to add data, but not trivial to remove data (although it can certainly be done with caution in a group meeting)*
- *All `git mega` setup steps have been completed in all RDHPCS. So we only need to follow step 1.1 for the Level 2 management of the RRFS2 fix files. Step 2 is provided below just for awareness*
### 1.1 
For example, we want to add a set of new static BEC files. We copy them to under `FIX_RRFS2/static_bec` as `conus12km_L60.20250606`
```
cd $FIX_RRFS2/static_bec
cp -rp $SRC conus12km_L60.20250606
# 1. Sanity check to ensure no SHA512SUM collisions:
git mega collision-check conus12km_L60.20250606  # this will take a few minutes

# 2. if everything is good, git mega deposit the new fix files into the MEGA space:
git mega deposit conus12km_L60.20250606

# 3. git add/commit/push
git add conus12km_L60.20250606
git commit -m "add static_bec/conus12km_L60.20250606/"
git push

# 4. sync to other platforms

```

# 2. Under the hood
### 2.1. install 
```
git clone git@github.com:git-mega/git-mega-rrfs
cd git-mega-rrfs
./build.sh
# isMegaFile will be generated under bin/
```

### 2.2 module load git-mega in .bashrc
eg:
```
vi .bashrc
#add the following line
#source /gpfs/f6/bil-fire10-oar/world-shared/gge/git-mega-rrfs/ush/load_git-mega.sh
```

### 2.3 Backup, Sync, and Uninstall
These are expected to be handled manually.  
The file change history is tracked by the `FIX_RRFS2` repo.  
Backup `$GITROOT/.mega/` to HPSS by `sbatch save2hpss.<machine>`  
Sync `$GITROOT/.mega/` between RDHPCS through either `rsync` or `globus`  
Uninstall by removing `$GITROOT/.mega.conf` and/or `$ GITROOT/.mega/`. Be sure to backup `$GITROOT/.mega/` before removing it.

# 3. MISC
### 3.1 list all mega files and find files with the same hashes
```
git mega ls-files . > tmp.txt
cut -d= -f2 tmp.txt | sort > hash.txt
uniq hash.txt > uniq.txt
sort hash.txt | uniq -d > duplicate.txt  # find duplicate lins in hash.txt
grep -f duplicate.txt tmp.txt > dup_files.txt  # files with duplicate hashes

## find lines only in hash.txt but not in uniq.txt
# vimdiff hash.txt uniq.txt
# comm -23 <(sort hash.txt) <(sort uniq.txt) | uniq > duplicate.txt

wc -l uniq.txt

find .mega -type f | wc -l
find .mega -type f | cut -c10- |sort  > mega.txt
```
