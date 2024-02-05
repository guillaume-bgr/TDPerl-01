package Monitoring;

    # $folder_path = './';
    sub list_files_folder {
        my ($folder_path) = @_;

        opendir(my $dh, $folder_path) or die "Cannot open directory $folder_path: $!";
        my @files = grep { -f "$folder_path/$_" } readdir($dh);
        closedir($dh);
        
        return @files;
    }

    sub read_log {
        my ($log_file_path) = @_;
        open(my $log_fh, '<', $log_file_path) or die "Cannot open log file $log_file_path: $!";
        my @log_entries;

        while (my $line = <$log_fh>) {
            chomp($line);
            # Parse log entry format
            if ($line =~ /^\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\] (\S+): (.+)$/) {
                my ($date, $level, $message) = ($1, $2, $3);

                # Extract additional information if needed
                my %log_entry = (
                    date => $date,
                    level     => $level,
                    message   => $message,
                );

                push @log_entries, \%log_entry;
            }
        }
        close($log_fh);
        return @log_entries;
    }

1;