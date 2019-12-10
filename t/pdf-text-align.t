use v6;
use Test;
plan 2;
use PDF::Lite;
use PDF::Content;
use PDF::Font::Loader;
# ensure consistant document ID generation
srand(123456);

my PDF::Lite $pdf .= new();
my PDF::Lite::Page $page = $pdf.add-page;
my PDF::Content $gfx = $page.gfx;
my $width = 100;
my $height = 80;
my $x = 110;

my $font = PDF::Font::Loader.load-font: :file<t/fonts/DejaVuSans.ttf>;

is-deeply $font.encode("Abc♠♥♦♣"), buf8.new(0,36, 0,69, 0,70, 15,56, 15,61, 15,62, 15,59), 'encode (identity-h)';

$gfx.text: -> $gfx {
    $gfx.font = $font, 10;

    my $sample = q:to"--ENOUGH!!--";
        Lorem ipsum dolor sit amet, consectetur adipiscing elit,  sed
        do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        --ENOUGH!!--

    my $baseline = 'top';

    for <top center bottom> -> $valign {

        my $y = 700;

        for <left center right justify> -> $align {
            $gfx.text-position = ($x, $y);
            $gfx.say( "*** $valign $align*** " ~ $sample, :$width, :$height, :$valign, :$align, :$baseline );
            $y -= 170;
        }

       $x += 125;
    }
}

lives-ok {$pdf.save-as('t/pdf-text-align.pdf')};

done-testing;
