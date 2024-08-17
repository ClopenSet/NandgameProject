# 遍历目录中的所有 .v 文件
for file in *.v; do
    # 创建一个宏名称，基于文件名
    guard_name=$(echo "$file" | tr '[:lower:]' '[:upper:]' | tr '.' '_')
    
    # 将当前文件内容复制到临时文件
    cp "$file" temp_file
    
    # 在文件开头添加 ifndef 和 define
    echo "`ifndef $guard_name" > "$file"
    echo "`define $guard_name" >> "$file"
    echo "" >> "$file"
    
    # 将原始文件内容追加回去
    cat temp_file >> "$file"
    
    # 在文件末尾添加 endif
    echo "" >> "$file"
    echo "`endif // $guard_name" >> "$file"
done

# 删除临时文件
rm temp_file