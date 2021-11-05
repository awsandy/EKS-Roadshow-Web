echo "build ...."
hugo serve -f public &
sleep 10
kill -9 %1
echo "s3 synch ...."
aws s3 sync public/ s3://at-workshop2/ --delete
echo ""
echo "http://at-workshop2.s3-website.eu-west-2.amazonaws.com/"
date
