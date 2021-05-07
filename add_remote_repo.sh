function add_remote_repo(){
        #Initializes a git repo and adds a remote repo for Bitbucket.
        if [[ -z $1 ]] || [[ $1 =~ \.git ]]
        then
                echo "You must provide a repo name. (Without '.git')"
                return 1
        fi

        if [[ $(basename "$PWD") != "$1" ]]
        then
                read 'answer?Repo name does not match current directory. Are you in the right directory? (y/N) '

                if [[ $answer != "y" ]]
                then
                        echo "Aborting adding remote repo."
                        return 1
                fi
        fi
        echo "\nCreating git repo. (git init)"
        git init
        echo "\nAdding files to repo. (git add .)"
        git add .
        echo "\nCommitting with 'Repo initialization'."
        git commit -m "Repo initialization."
        git remote add origin git@bitbucket.org:iambj/$1.git && echo "\nAdded origin successfully.\n"
        git push --set-upstream origin master && echo "\nInitial push successful. Remote is setup.\n"
}