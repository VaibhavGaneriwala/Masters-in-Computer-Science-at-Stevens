// 15 Oct 2024
// eb6.3

class Barr {
    private int c
    private final int B
    Barr(int size) {
	c=0
	B=size
    }
    synchronized void synch() {
	if (c<B) {
	    c++
	    while (c<B) {
		wait()
	    }
	    notify() // cascaded signalling
	}
    }
}

final int N=3
final int B=3

Barr b = new Barr(B)

N.times {
    int id = it
    Thread.start {
	    print "a$id"
	    b.synch()
	    print "1$id"
    }
}
