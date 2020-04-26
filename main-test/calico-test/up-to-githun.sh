git add .
COMMIT=$(head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | fold -w 3 | head -n 1)
git commit -m $COMMIT
git push
