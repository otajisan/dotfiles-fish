#!/user/local/bin/perl

use strict;
use warnings;
use utf8;

use Term::ANSIColor qw( :constants );
$Term::ANSIColor::AUTORESET = 1;
sub main
{
    info('############ set up start. ############');

    # 引数がない
    if (@ARGV == 0) {
        error("invalid argument. please assign home dir.");
        &print_usage();
        exit(1);
    }

    my $home = $ARGV[0];

    # インストール先のディレクトリがない
    if (!(-d $home)) {
        error("invalid path. '$home' not exists");
        &print_usage();
        exit(1);
    }

    # fish
    #&install_fish();
    #&install_oh_my_fish();
    # ドットファイルコピー
    &copy_dotfiles($home);
    &reload_fish_config();
    &install_oh_my_fish_plugins($home);
    &install_neovim();
    # colorschmeをインストール
    #&install_colorscheme($home);
    # NeoBundleインストール
    #&install_NeoBundle($home);
    # gitの設定
    #&setup_git($home);

    success();

    exit(0);
}

sub install_fish()
{
    my ($status, $output) = exec_cmd("which fish");
    if ($output ne "") {
        exec_cmd("brew upgrade fish");
    } else {
        exec_cmd("brew install fish");
    }

    exec_cmd("echo /usr/local/bin/fish | sudo tee -a /etc/shells");
    exec_cmd("chsh -s `which fish`");
    my ($_, $version) = exec_cmd("fish -v");
    print $version."\n";
}

sub install_oh_my_fish()
{
    exec_cmd("curl -L https://get.oh-my.fish | fish");
}

sub install_oh_my_fish_plugins()
{
    my ($home) = shift;
    exec_cmd("omf install cd");
    exec_cmd("omf install peco");
    exec_cmd("omf install agnoster");
    exec_cmd("omf install lolfish");
    exec_cmd("wget -O $home/.config/fish/conf.d/lol.fish https://github.com/er0/lolfish/raw/master/lol.fish");
    exec_cmd("omf install shellder");
    exec_cmd("omf install slavic-cat");
    exec_cmd("omf theme slavic-cat");

}

sub copy_dotfiles()
{
    my ($home) = shift;
    copy_file("./files/.config/fish/conf.d/my.fish", "$home/.config/fish/conf.d/my.fish");
    copy_file("./files/.config/fish/conf.d/alias.fish", "$home/.config/fish/conf.d/alias.fish");
}

sub reload_fish_config()
{
    my ($home) = shift;
    exec_cmd(". ~/.config/fish/conf.d/my.fish");
}

sub install_neovim()
{
    exec_cmd("brew install neovim");
    exec_cmd("brew install the_silver_searcher");
}

sub install_colorscheme
{
    my ($home) = shift;

    info(">>>> start install colorschme");

    if (-f "$home/.vim/colors/molokai.vim") {
        info("molokai is alerady installed.");
        return 0;
    }

    info("now installing colorscheme");
    exec_cmd("mkdir -p $home/.vim/colors");
    # molokai
    exec_cmd("git clone https://github.com/tomasr/molokai");
    exec_cmd("mv molokai/colors/molokai.vim ~/.vim/colors/");
    exec_cmd("rm -fR molokai");
    return 1;
}

sub setup_git
{
    my ($home) = shift;
    my $file_root = './files';

    info(">>>> start setup git");

    if (-f "$home/git-completion.bash" && -f "$home/git-prompt.sh") {
        info("git setup is already done.");
        return 0;
    }

    # config files
    exec_cmd("cp $file_root/git-completion.bash $home");
    exec_cmd("cp $file_root/git-prompt.sh $home");

    # setting
    exec_cmd("git config --global user.name otajisan");
    exec_cmd("git config --global color.ui auto");

    # alias
    exec_cmd("git config --global alias.co checkout");
    exec_cmd("git config --global alias.ci commit");
    exec_cmd("git config --global alias.st status");
    exec_cmd("git config --global alias.br branch");
    exec_cmd("git config --global alias.hist 'log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short'");

    # my git ignore
    exec_cmd("cp $file_root/.gitignore $home");
    exec_cmd("git config --global core.excludesfile ~/.gitignore");

    return 1;
}

sub copy_file
{
    my ($src, $dest) = @_;
    my ($status, $output) = exec_cmd("diff -u $src $dest");
    if ($status == 1) {
        warning("diff found. please confirm file below.");
        print YELLOW $dest."\n";
        print CYAN $output."\n";
        return;
    }
    print $output."\n";
    exec_cmd("cp $src $dest");
}

sub print_usage
{
    error("*********** Usage ***********");
    error("perl setup.pl /home/hoge");
}

sub exec_cmd
{
    my ($cmd) = shift;
    info($cmd);
    my $output = `$cmd 2>&1`;
    chomp($output);
    my $status = $? / 256;
    return ($status, $output);
}

sub info    { _log('INFO' , shift);            } # INFO
sub warning { _log('WARN', shift);            } # WARN
sub error   { _log('ERROR', shift);            } # ERROR
sub success { _log('OK'   , 'success!!!!!!!'); } # SUCCESS
sub _log
{
    my ($level, $message) = @_;
    print "[";
    # レベル毎に色付け
    if ($level eq 'INFO') {
        print BLUE $level;
    } elsif ($level eq 'WARN') {
        print YELLOW $level;
    } elsif ($level eq 'ERROR') {
        print RED $level;
    } elsif ($level eq 'OK') {
        print GREEN $level;
    }
    print "]";
    print "$message\n"
}


&main();
