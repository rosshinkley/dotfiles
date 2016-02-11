# Protips

### find/replace inline
```bash
find . -name '*.ext' -exec perl -pi.bak 's/find/replace/g' {} \;
```

### lowercase all filenames
```bash
find my_root_dir -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;
```

### remove all files of extension
```bash
find . -name "*.bak" -type f -delete
```
