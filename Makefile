default:

install:
	mkdir -p .git/hooks
	cp git-pow-postcommit.sh .git/hooks/post-commit
	chmod +x .git/hooks/post-commit
