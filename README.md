


## Reference

* [Linux/UNIX: Bash Read a File Line By Line](https://www.cyberciti.biz/faq/unix-howto-read-line-by-line-from-file/)

```
while IFS= read -r line
do
  echo "$line"
done < "$input"
```