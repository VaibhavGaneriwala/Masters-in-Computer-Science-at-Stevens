import java.util.concurrent.Semaphore;

Semaphore station0 = new Semaphore(1)
Semaphore station1 = new Semaphore(1)
Semaphore station2 = new Semaphore(1)

permToProcess = [ new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines
doneProcessing = [new Semaphore(0), new Semaphore(0), new Semaphore(0)] // list of semaphores for machines

100.times {
    Thread.start { // Car
        // Go to station 0
	station0.acquire()
	permToProcess[0].release()
	doneProcessing[0].acquire()

	station1.acquire()
	station0.release()
	
        // Move on to station 1
	permToProcess[1].release()
	doneProcessing[1].acquire()

	station2.acquire()
	station1.release()
	
        // Move on to station 2
	permToProcess[2].release()
	doneProcessing[2].acquire()
	station2.release()

        // Move on to station 2
      }
}

3.times { 
    int id = it; // iteration variable
    Thread.start { // Machine at station id
        while (true) {
            // Wait for car to arrive
	    permToProcess[id].acquire()
            // Notify car when done
	    doneProcessing[id].release()
            }
    }
}
