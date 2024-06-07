#!/usr/bin/env bash

orange='\033[0;33m'
reset='\033[0m'

# Function to print text in light blue color
print_light_blue() {
  local text="$1"
  echo -e "${orange}${text}${reset}"
}

# function for application loader
function load {
  for i in {1..10}; do
    echo -n "."
    sleep 0.1
  done
  echo -e "100%\n"
} 


echo -e "\n\n"
echo -e "███╗   ██╗███████╗ ██████╗ ██████╗  ██████╗ ██████╗      ██╗██████╗ "
echo -e "████╗  ██║██╔════╝██╔════╝ ██╔══██╗██╔═══██╗██╔══██╗    ███║╚════██╗"
echo -e "██╔██╗ ██║█████╗  ██║  ███╗██████╔╝██║   ██║██║  ██║    ╚██║ █████╔╝"
echo -e "██║╚██╗██║██╔══╝  ██║   ██║██╔═══╝ ██║   ██║██║  ██║     ██║██╔═══╝ "
echo -e "██║ ╚████║███████╗╚██████╔╝██║     ╚██████╔╝██████╔╝     ██║███████╗"
echo -e "╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝      ╚═════╝ ╚═════╝      ╚═╝╚══════╝"
echo 
echo "\n"

echo -n "Loading"
load

export file_path="Students-list_1023.txt"

#----------------------------------------function To Register student
function register {
  # get inputs with function
  read -p "Enter Student Email: " email
  read -p "Enter Student Age: " age
  #must be in formmat like this [ALU2023001]
  read -p "Enter Student Id: " id

  if [[ $email == *"@alustudent.com" ]]; then
    if [ -e "$file_path" ]; then
      echo "adding student"
    else
      printf "+----------------------------+----------------------------+-------------------------------------\n" > $file_path
      printf "| %-26s | %-26s | %-36s |\n" "student Id" "Age" "Email" >> $file_path
      printf "+----------------------------+----------------------------+-------------------------------------\n" >> $file_path
      echo "Creating Table and Adding Data"
    fi
    sleep 1
    # use grep to search if student id column exists
    if grep -E "^\|[[:space:]]*$id[[:space:]]*\|" $file_path; then
      # message notification
      echo -e "\n\n****The student Id Already Exists***\n"
      # restart app for the user to enter new data
      sleep 2
      clear
      ./main.sh
    else
      # Print table rows
      printf "| %-25s | %-26s | %-36s |\n" "$id" "$age" "$email" >> $file_path
      printf "+----------------------------+----------------------------+-------------------------------------\n" >> $file_path
      # loading message
      echo -n "opening preview loading ";
      load
      # end of loading
      cat $file_path
      echo -e "\n\n returning to Home\n\n"
      load
      # end of loading
      clear
      ./main.sh
    fi
  else
    echo -e "\n\n**************** This is Not A valid ALU Student Email ****************\n\n"
    # call the register function if invalid email to allow the user to input again
    register
  fi
}

# function to view all students
function view_student {
  # Check if the file exists
  if [ -f "$file_path" ]; then
    # check if file is empty
    if [ -s "$file_path" ]; then
      # message
      echo -e "\n\n \t\t\t*** Viewing All Students ***\n\n\n"
      # display students
      cat "$file_path"
      # and also call restart the app for user to choose other
      ./main.sh
    else
      echo "No Student Found. Try Adding New Students."
      echo -e "\n\n **** returning to Home **** \n\n"
      # call the load function
      load
      # clear everything and restart the app for user
      clear
      ./main.sh
    fi
  else
    echo "File Not Found."
    echo -e "\n\n **** returning to Home **** \n\n"
    load
    clear
    ./main.sh
  fi
}

#----------------------------function To Update Student----------------------
function update_student {
  # check if file exists
  if [ -f "$file_path" ]; then
    # get email
    read -p "Enter The Student Id To Edit: " id

    # check existence of the student id
    if grep -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path"; then
      # message to the being edited
      echo -e "\nYou Are Editing this User\n"
      # get data from user: age and email
      read -p "Enter New Age: " age
      read -p "Enter New Email: " email

      if [[ $email == *"@alustudent.com" ]]; then
        temp_file="temp_file"
        found=false
        while IFS= read -r line; do
          if echo "$line" | grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|"; then
            printf "| %-26s | %-26s | %-36s |\n" "$id" "$age" "$email" >> "$temp_file"
            found=true
          else
            echo "$line" >> "$temp_file"
          fi
        done < "$file_path"
        
        if [ "$found" = false ]; then
          echo "Student ID: $id not found in the file."
          echo -e "\n\n **** returning to Home **** \n\n"
          load
          # end of loading
          clear
          ./main.sh
        else
          mv "$temp_file" "$file_path"
          echo "Successfully Edited Student with ID: $id"
          echo -e "\n\n **** Preparing Your Preview **** \n\n"
          load
          # end of loading
          clear
          view_student
        fi
      else
        echo -e "\n\n**************** This is Not A valid ALU Student Email ****************\n\n"
        update_student
      fi
    else
      echo "Error: Student Id Doesn't exist: $id"
      echo -e "\n\n **** returning to Home **** \n\n"
      load
      # end of loading
      clear
      ./main.sh
    fi
  else
    echo "Error: File not found : $file_path"
    echo -e "\n\n **** returning to Home **** \n\n"
    load
    # end of loading
    clear
    ./main.sh
  fi
}

#---------------------------------------function to Delete student------------------
function delete_student {
    # Get student Id
    read -p "Enter The Student Id To Delete: " id

    # Check if file Exists To Avoid Errors
    if [ -f "$file_path" ]; then
        # Use Grep To Search Student Id that matches the pattern
        grep -E -n "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path" | while read -r line; do
            # Lines matches including numbers and split them (with line numbers)
            line_num=$(echo "$line" | cut -d ':' -f 1)
            # Delete the line that matched the search and the next line
            sed -i "${line_num}d;$(($line_num+1))d" "$file_path"
        done
        echo "Deleted row with Student ID: $id"

        echo -e "\n\n **** Preparing Your Preview **** \n\n"
        load
        # End of loading 
        clear
        view_student
    else
        echo "Error: File not found at path: $file_path"
        echo -e "\n\n **** returning to Home ****\n\n"
        load
        # End of loading 
        clear
        ./main.sh
    fi
}

#------------------------function to save in new file ------------------------------
function email_save {
    echo -n "Saving Emails in ASC"
    sleep 0.6
    clear
    ./select-emails.sh
}

emails='student-emails.txt'

#------------------------function to view emails in ASC order-----------------------
function view_email {
    # Loading message
    echo -n "Opening Emails preview in ASC Order"
    load
    # End of loading
    cat "$emails"
    ./main.sh
}

#------------------------function to backup data
function back_up {
    read -p "Are you sure you want to backup your data? (Y or N) If you backup this data, everything will be backed up and you won't be able to run this program unless you go to the online server or backup directory: " opt

    if [ "$opt" == 'Y' ] || [ "$opt" == 'y' ]; then
        echo -n "Opening Backup"
        load
        ./move-to-directory.sh
    else
        echo "$opt"
        echo -n "Returning to home"
        load
        ./main.sh
    fi
}

#------------------------function to exit program---------------
function exit_main {
    # Send message for closing app
    echo -n "Closing App. Please wait for a few seconds to finish..."
    sleep 0.6
    clear
    # Kill the main process
    pkill -f './main.sh'
}

# App menu
echo -e "\n\n*******************************************************"
echo -e "****************** Student Management System *****************"
echo -e "*******************************************************\n"

echo -e "What would you like to do today?\n"

echo "╔═══════════════════════════════════════════════════╗"
echo "║                  Main Menu                        ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║    1. Add New Student                             ║"
echo "║    2. View All Students                           ║"
echo "║    3. Update Student                              ║"
echo "║    4. Delete Student                              ║"
echo "║    5. Save Student Emails Sorted in ASC           ║"
echo "║    6. View All Emails Only in ASC Order           ║"
echo "║    7. Backup your data                            ║"
echo "║    8. Exit                                        ║"
echo "╚═══════════════════════════════════════════════════╝"

echo -e "\nEnter your choice (1-8): "

# Allow the user to input their choice with read function
echo -e "\n"
read -p "Enter Your choice Here: " choice
echo -e "\n"

# Switch case to call functions according to user need
case $choice in
    1)
        register
        ;;
    2)
        view_student
        ;;
    3)
        update_student
        ;;
    4)
    
        delete_student
        ;;
    5)
        email_save
        ;;
    6)
        view_email
        ;;
    7)
        back_up
        ;;
    8)
        exit_main
        ;;
    *)
        echo "Invalid choice. Please try again."
        ./main.sh
        ;;
esac

