package Alert;

    sub sendMail {
        my $message = $_[0];
        my $subject = $_[1];
        my $to = $_[2];
        my $msg = MIME::Lite->build(
            From     => 'logwatcher@quackcode-technologies.com',
            To       => "$to",
            Subject  => "$subject",
            Type     => 'TEXT/html',
            Encoding => 'quoted-printable',
            Data     => "$message"
        );
        $msg->send('smtp', "sandbox.smtp.mailtrap.io", Port=>2525, Hello=>"sandbox.smtp.mailtrap.io", AuthUser=>"c52d0b867f59be", AuthPass=>"b9c3dd9967fa93");
        print "Email Sent Successfully\n";
    }

1;