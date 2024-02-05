use DBI;

package Database;
    our $dbh = undef;

    # our $db_host = 'localhost';
    # our $db_name = 'logwatcher';
    # our $db_user = 'root';
    # our $db_pass = '';
    sub init_bdd {
        my ($class, $db_name, $db_host, $db_user, $db_pass) = @_;

        $dbh = DBI->connect(
            "DBI:mysql:database=$db_name;
            host=$db_host",
            $db_user,
            $db_pass,
            { PrintError => 0, RaiseError => 1 }
        );
    }

    # my $table = 'warning';
    # my $columns = ['id', 'message', 'date'];
    # my $where = 'message LIKE %test%';
    # my $offset = 0;
    # my $limit = 10;
    # my $results = Database->select_bdd('warning', ['id', 'message', 'date'], $where, $offset, $limit);
    sub select_bdd {
        my ($class, $table, $columns, $where, $offset, $limit) = @_;
        my $self = {};
        bless $self, $class;
        my $dbh = $self->{_dbh} || $dbh;

        my $column_list = join(', ', @$columns);
        my $sql = "SELECT $column_list FROM $table";
        $sql .= " WHERE $where" if $where;
        if (defined $limit) {
            $sql .= " LIMIT $limit";
        }
        if (defined $offset) {
            $sql .= " OFFSET $offset";
        }

        my $sth = $dbh->prepare($sql);
        $sth->execute();
        my @results;
        while (my $row = $sth->fetchrow_hashref()) {
            push @results, $row;
        }
        return \@results;
    }

    # my $table = 'warning';
    # my $columns = ['message', 'date'];
    # my $values = ['test', '2024-02-03 12:34:56'];
    sub insert_bdd {
        my ($class, $table, $columns, $values) = @_;
        my $self = {};
        bless $self, $class;
        my $dbh = $self->{_dbh} || $dbh;

        my $column_list = join(', ', @$columns);
        my $value_placeholders = join(', ', ('?') x scalar(@$values));
        my $sql = "INSERT INTO $table ($column_list) VALUES ($value_placeholders)";
        my $sth = $dbh->prepare($sql);
        $sth->execute(@$values);
    }

    # my $table = 'warning';
    # my $columns_and_values = {
    #     'message' => 'test 2',
    #     'date'    => '2024-02-03 14:00:00',
    # };
    # my $where = 'id = 1'; 
    sub update_bdd {
        my ($class, $table, $columns_and_values, $where) = @_;
        my $self = {};
        bless $self, $class;
        my $dbh = $self->{_dbh} || $dbh;

        my @set_clause;
        foreach my $column (keys %$columns_and_values) {
            push @set_clause, "$column = ?";
        }

        my $set_clause = join(', ', @set_clause);
        my $sql = "UPDATE $table SET $set_clause";
        $sql .= " WHERE $where" if $where;

        my $sth = $dbh->prepare($sql);
        $sth->execute(values %$columns_and_values);

        return $sth->rows; 
    }

    # my $table = 'warning';
    # my $where = 'id = 1';
    sub delete_bdd {
        my ($class, $table, $where) = @_;
        my $self = {};
        bless $self, $class;
        my $dbh = $self->{_dbh} || $dbh;

        my $sql = "DELETE FROM $table";
        $sql .= " WHERE $where" if $where;

        my $sth = $dbh->prepare($sql);
        $sth->execute;

        return $sth->rows;
    }

    sub close_bdd {
        my ($class) = @_;
        my $self = {};
        bless $self, $class;

        if ($self->{_dbh}) {
            $self->{_dbh}->disconnect;
            $self->{_dbh} = undef;
        }
    }

1;