#Get extra log when running playbook | for debuging
ansible-playbook -i host run.yaml --tags="p_1.1.22" -vvvv

#Run one tag only
ansible-playbook -i host run.yaml --tags="p_1.1.23"

#Skips tags
ansible-playbook -i host run.yaml --skip-tags="p_1.4.1" --skip-tags="p_2.2.1.1"