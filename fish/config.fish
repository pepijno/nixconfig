set PATH /opt/apache-maven/bin $PATH

function goto-repo --argument-names 'query'
	set REPOS /Users/poverbeeke/Desktop/Repos/
	if test -n "$query"
		set repo (ls $REPOS | fzf -q $query)
	else
		set repo (ls $REPOS | fzf)
	end
	if [ " $repo" != " " ]
		set gotoDir "$REPOS$repo"
		cd $gotoDir
		git f
	end
end

function git
	if test (count $argv) -gt 0 -a "$argv[1]" = "goto"
		set --erase argv[1]
		goto-repo $argv
	else
		/usr/bin/git $argv
	end
end

#function kubectl
#	echo $argv
#	echo (test (count $argv) -gt 0 -a "$argv[1] = $config" -a "$argv[2]" = "use-context")
#	if test (count $argv) -gt 0 -a "$argv[1]" = "config" -a "$argv[2]" = "use-context"
#		/usr/local/bin/kubectl $argv
#		echo $status
#		if test $status -eq 0
#			set -U minikube_context $argv[3]
#		end
#	end
#end

function config
	/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end
