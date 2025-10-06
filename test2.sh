#!/bin/bash

# Скрипт WeekSchedule.sh
# Автор: Пример (вместо реальной фамилии и имени)

# Переменные
PATTERN="WeekSchedule"
DAYS=("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
TIMETABLE_FILE="$HOME/Timetable_Ivanov"

# 1. Создать 7 каталогов одной командой (в цикле через for)
for i in {1..7}; do mkdir -p "$PATTERN$i"; done

# 2. В каждом каталоге создать пустой файл с названием дня недели (используя цикл и массив)
for i in {1..7}; do
    dir="$PATTERN$i"
    day="${DAYS[$((i-1))]}"
    touch "$dir/$day"
done

# Создать базовый файл daily_routine.txt с 20 строками рутинных действий на русском (для случайного выбора в п.3)
cat > daily_routine.txt << EOF
проснуться
поужинать
встать
принять душ
почистить зубы
пойти на работу
пообедать
позавтракать
сделать домашнее задание
пойти домой
пойти в школу
лечь спать
Есть
Спать
Одежда
Учиться
Заниматься спортом
Читать
Смотреть телевизор
Готовить
EOF

# 3. Для каждого файла дня недели: 16 раз случайно выбрать строку из daily_routine.txt и дописать
for i in {1..7}; do
    dir="$PATTERN$i"
    day="${DAYS[$((i-1))]}"
    file="$dir/$day"
    for j in {1..16}; do
        lines=$(wc -l < daily_routine.txt)
        rand_line=$((RANDOM % lines + 1))
        sed -n "${rand_line}p" daily_routine.txt >> "$file"
    done
done

# 4. Упорядочить по алфавиту содержимое каждого файла (sort)
for i in {1..7}; do
    dir="$PATTERN$i"
    day="${DAYS[$((i-1))]}"
    file="$dir/$day"
    sort "$file" -o "$file"
done

# 5. Добавить в начало каждой строки время от 8:00 до 23:00 и выровнять по колонкам (используя printf и column)
hours=($(seq -f "%g:00" 8 23))
for i in {1..7}; do
    dir="$PATTERN$i"
    day="${DAYS[$((i-1))]}"
    file="$dir/$day"
    mapfile -t lines < "$file"
    # Создать временный файл с временем и действиями
    temp_file="${file}.tmp"
    > "$temp_file"
    for k in {0..15}; do
        printf "%s %s\n" "${hours[k]}" "${lines[k]}" >> "$temp_file"
    done
    # Выровнять по колонкам (column -t для автоматического выравнивания)
    column -t "$temp_file" > "$file"
    rm "$temp_file"
done

# 6. Создать объединенный файл Timetable_Ivanov в домашней директории
> "$TIMETABLE_FILE"  # Очистить/создать файл
for i in {1..7}; do
    dir="$PATTERN$i"
    day="${DAYS[$((i-1))]}"
    file="$dir/$day"
    echo "Файл: $day из $dir" >> "$TIMETABLE_FILE"
    cat "$file" >> "$TIMETABLE_FILE"
    echo "" >> "$TIMETABLE_FILE"  # Пустая строка
done

echo "Скрипт WeekSchedule.sh выполнен успешно! Timetable_Ivanov создан в ~."