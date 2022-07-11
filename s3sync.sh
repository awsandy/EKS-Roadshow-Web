echo "build ...."
hugo serve -d public &
echo "sleep 15 ....."
sleep 15
kill -9 %1
echo "s3 synch ...."
aws s3 sync public/ s3://at-workshop2/ --delete
echo "http://at-workshop2.s3-website.eu-west-2.amazonaws.com/"
date
aws cloudfront create-invalidation --distribution-id E3JTK2VCPNHPVG --paths "/*"
