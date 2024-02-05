use FindBin;
use lib $FindBin::Bin;
use File::Slurper 'read_text';
use MIME::Lite;
use Data::Dumper;
use DBI;
use Database;
use Monitoring;
use Alert;

our $db_host = 'localhost';
our $db_name = 'logwatcher';
our $db_user = 'root';
our $db_pass = '';
my @files_in_folder = Monitoring::list_files_folder('./logs');

foreach my $file (@files_in_folder) {
    @log_entries = Monitoring::read_log("./logs/$file");
    
    $nbWarnings = 0;
    $nbErrors = 0;
    @warnings = ();
    @errors = ();
    

    foreach my $log_entry (@log_entries) {
        if ($log_entry->{level} eq 'ERROR') {
            $nbErrors++;
            push @errors, $log_entry;
        } elsif ($log_entry->{level} eq 'WARNING') {
            $nbWarnings++;
            push @warnings, $log_entry;
        }
        # print "date: $log_entry->{date}, Level: $log_entry->{level}, Message: $log_entry->{message}\n";
    }

    Database->init_bdd($db_name, $db_host, $db_user, $db_pass);
    $warningHtml = '';
    foreach my $warning (@warnings) {
        my $results = Database->select_bdd('warning', ['id', 'message', 'date'], "message = '$warning->{message}'");
        if (!@$results) {
            Database->insert_bdd('warning', ['message', 'date'], [$warning->{message}, $warning->{timestamp}]); 
        }
        $warningHtml .= 
        "<li>
        <p>Date: $warning->{date}</p>
        <p>Message: $warning->{message}
        </li>"
    }
    $errorHtml = '';
    foreach my $warning (@warnings) {
        my $results = Database->select_bdd('warning', ['id', 'message', 'date'], "message = '$warning->{message}'");
        if (!@$results) {
            Database->insert_bdd('warning', ['message', 'date'], [$warning->{message}, $warning->{timestamp}]); 
        }
        $errorHtml .= 
        "<li>
        <p>Date: $warning->{date}</p>
        <p>Message: $warning->{message}</p>
        </li>"
    }
    foreach my $error (@errors) {
        my $results = Database->select_bdd('error', ['id', 'message', 'date'], "message = '$error->{message}'");
        if (!@$results) {
            Database->insert_bdd('error', ['message', 'date'], [$error->{message}, $error->{timestamp}]); 
        }
        $errorHtml .= 
        "<li>
        <p>Date: $error->{date}</p>
        <p>Message: $error->{message}</p>
        </li>"
    }
    
    Alert::sendMail(
        "<h1>Bonjour, ce message provient du LogWatcher afin de vous notifier des erreurs advenues sur votre solution.</h1>
        <p>$nbErrors erreurs</p>
        <h2>Messages d'erreur :</h2>
        <ul>
        $errorHtml
        </ul>
        ",
        'Logs QuackCode Technologies', 
        'administrateur@quackcode-technologies.com'
    );
    Alert::sendMail(
        "<h1>Bonjour, ce message provient du LogWatcher afin de vous notifier des erreurs et avertissements advenus sur votre solution.</h1>
        <p>$nbErrors erreurs</p>
        <p>$nbWarnings avertissements</p>
        <h2>Messages d'avertissements :</h2>
        <ul>
        $warningHtml
        </ul>
        <h2>Messages d'erreur :</h2>
        <ul>
        $errorHtml
        </ul>
        ",
        'Logs QuackCode Technologies', 
        'technicien@quackcode-technologies.com'
    );
}



