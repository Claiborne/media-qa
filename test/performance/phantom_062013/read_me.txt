How to run in AWS:

- Log into the AWS EC2 instance(s):
  ssh -i ~/.ec2/externalqa-aws-ign.pem ec2-user@{PUBLIC DNS}
  
- Run Jmeter w/ defined property value(s) (-Jname=value):  
  $ cd apache-jmeter-2.9/bin
  $ sh jmeter -n -t phantom_062013_aws.jmx -Jcontent=2 -Jsocial=2
    - Notes
	  -n (run in non-gui mode)
	  -t jmx file
	  -l log file
  Notes: Logging should output to terminal. In jmeter.properties set 'summariser.interval=5' and 'summariser.out=true' 
