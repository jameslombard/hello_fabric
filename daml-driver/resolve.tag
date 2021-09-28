#!/bin/bash
# Final merge request commit:

BRANCH=$(git branch --show-current)
git add -A 
git commit --allow-empty -m "Resolve" -m "Final commit for merge-request of $BRANCH into development" 
git push origin $BRANCH

