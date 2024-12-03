// 15 Oct 2024
// eb6.1

class Bar {
    private int up // unused patriots
    private boolean late
    Bar() {
	up=0
	late=false
    }
    synchronized void patriot() {
	up++
	if (up>1) {
	    notify()
	}
    }
    synchronized void jets() {
	while (up<2 && !late) { 
	    wait()
	}
	if (!late) {
	    up = up-2
	}
    }
    synchronized void itGotLate() {
	late=true
	notifyAll()
    }
}

final int J=20
final int P=20

Bar b = new Bar()
// Problem invariant: p >= 2*j
P.times {
    Thread.start {
	b.patriot()
    }
}

J.times {
    Thread.start {
	b.jets()
    }
}

Thread.start {
    sleep(2000)
    b.itGotLate()
