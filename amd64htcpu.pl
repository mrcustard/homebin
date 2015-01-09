#!/usr/bin/perl -w
#
# amd64htcpu - measure HT write throughput by socket on AMD64 processors.
#
# USAGE: amd64htcpu [interval]
#   eg,
#        amd64htcpu 2.5			# for 2.5 second intervals
#
# This shows the number of Mbytes read, written and total DRAM accesses.

use strict;
use Sun::Solaris::Kstat;
my $kstat = Sun::Solaris::Kstat->new();

my $interval = @ARGV > 0 ? shift : 1;			# default 1 sec
fail("interval $interval is invalid.") if $interval < 0.01;

#
# System Info
#
my $tcpus = $kstat->{unix}{0}{system_misc}{ncpus};		# total cpus
my $cpus = $kstat->{unix}{0}{pset}{ncpus};			# cpus online
my $cores = $kstat->{cpu_info}{0}{cpu_info0}{ncore_per_chip};	# assume exists
fail("sysinfo (cpus:$cpus / cores:$cores ?)") if $cpus == 0 or $cores == 0;
my $sockets = $tcpus / $cores;

#
# PIC Info
#
my $pics = 'NB_ht_bus0_bandwidth,umask0=0x37,sys0';	# HT0 Util
$pics .= ',NB_ht_bus1_bandwidth,umask1=0x37,sys1';	# HT1 Util
$pics .= ',NB_ht_bus2_bandwidth,umask2=0x37,sys2';	# HT2 Util
$pics .= ',NB_ht_bus3_bandwidth,umask3=0x37,sys3';	# HT3 Util
my $bytesperunit = 4;					# see p361 of BKDG

#
# Begin cpustat
#
$SIG{INT} = $SIG{QUIT} = $SIG{TERM} = \&cleanup;
open CPUSTAT, "/usr/sbin/cpustat -c $pics $interval |" or fail("cpustat: $!");

my ($lines, $s, @ht0, @ht1, @ht2, @ht3);

while (<CPUSTAT>) {
	next if ++$lines == 1;
	my @data = split;
	my $s = int($data[1] / $cores);
	$ht0[$s] += $data[3];
	$ht1[$s] += $data[4];
	$ht2[$s] += $data[5];
	$ht3[$s] += $data[6];

	if ((($lines - 1) % $cpus) == 0) {
		printf "   %8s %12s %12s %12s %12s\n", "Socket",
		    "HT0 TX MB/s", "HT1 TX MB/s",
		    "HT2 TX MB/s", "HT3 TX MB/s";
		foreach my $s (0..($sockets - 1)) {
			printf "   %8d %12.2f %12.2f %12.2f %12.2f\n", $s,
			    process($ht0[$s]), process($ht1[$s]),
			    process($ht2[$s]), process($ht3[$s]);
			$ht0[$s] = $ht1[$s] = $ht2[$s] = $ht3[$s] = 0;
		}
	}
}

sub process {
	my $data = shift;
	return 0 if not defined $data;
	$data *= $bytesperunit;		# bus I/Os to bytes
	$data /= $cores;		# each core reports same PIC
	$data /= $interval;		# by second
	$data /= 1 << 20;		# by Mbyte
	return $data;
}

sub cleanup {
	print "\nstopping cpustat...\n";
	close CPUSTAT;
}

sub fail {
	my $msg = shift;
	die "ERROR: $msg\n";
}
