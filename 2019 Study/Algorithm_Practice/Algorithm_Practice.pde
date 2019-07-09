Practice obj = new Practice();
QuickSort obj2 = new QuickSort();
int x = 5;
int sort[] = {3,1,2,5,4};
int sorted[] = new int[sort.length];

void setup()  {
  //size(10,10);
  frameRate(30);
  
  println("Factorial of "+x+ " is "+obj.factorial(x));
  println("Sum of 1 to "+x+ " is "+obj.sum(x));
  obj.bubbleSort(sort);
  //obj.doSomething(sort);
}

void draw()  {

}

class Practice {  
    
  int factorial(int value)  {
    
    if(value == 1)  {
    return value;
    }
    return value * factorial(value-1);
    
  }
  
   int sum(int value)  {
     
     if(value == 1)  {
       return value;
     }
     return value + sum(value-1);
     
   }
   
   void bubbleSort(int val[])  {
     
     println("Unsorted Array");
     for(int x : val)  {
       print(x+" ");
     }
     
     int temp;
     boolean swapped;
     for(int i = 0; i < val.length; i++)  {
       for(int j = i+1; j < val.length; j++)  {
          swapped = false;
         if(val[i] > val[j])  {
           temp = val[i];
           val[i] = val[j];
           val[j] = temp;
           swapped = true;
         }
         if(swapped == true){
          break;
         }
       }
     }
     
     println("\nSorted Array via bubblesort");
     for(int x : val)  {
       print(x+" ");
     }
     
   }
   
   void doSomething(int arr[])  {
     int mid = arr.length/2;
     int temp;
     for(int i = 0; i < mid; i++)  {
       for(int j = i+1; j < mid; j++)  {
         
         if(arr[i] > arr[j])  {
             temp = arr[i];
             arr[i] = arr[j];
             arr[j] = temp;
         }
       }
     }
     for(int i = mid-1; i < arr.length; i++)  {
       for(int j = i+1; j < arr.length; j++)  {
         
         if(arr[i] > arr[j])  {
             temp = arr[i];
             arr[i] = arr[j];
             arr[j] = temp;
         }
       }
     }
     
     println("\nSorted Array via exp-sort");
     for(int x : arr)  {
       print(x+" ");
     }
   }

}

//***********************************************************************************  

//Experimental Modifie Bubble Sort
class ExpSort  {
  int temp;
  int pivot;
  
  ExpSort(int arr[])  {
    pivot = arr.length/2;
    if(pivot != arr.length)  {
    for(int i = 0; i < pivot; i++)  {
       for(int j = i+1; j < pivot; j++)  {
         
         if(arr[i] > arr[j])  {
             temp = arr[i];
             arr[i] = arr[j];
             arr[j] = temp;
         }
       }
     }
    }
     //if(pivot != arr.length) ExpSort(arr);
     pivot = arr.length;
  }
  
}




//Quick Sort Study 
// Java program for implementation of QuickSort 
class QuickSort 
{ 
    /* This function takes last element as pivot, 
       places the pivot element at its correct 
       position in sorted array, and places all 
       smaller (smaller than pivot) to left of 
       pivot and all greater elements to right 
       of pivot */
    int partition(int arr[], int low, int high) 
    { 
        int pivot = arr[high];  
        int i = low-1; // index of smaller element 
        for (int j=low; j<high; j++) 
        { 
            // If current element is smaller than or 
            // equal to pivot 
            if (arr[j] <= pivot) 
            { 
                i++; 
  
                // swap arr[i] and arr[j] 
                int temp = arr[i]; 
                arr[i] = arr[j]; 
                arr[j] = temp; 
            } 
        } 
  
        // swap arr[i+1] and arr[high] (or pivot) 
        int temp = arr[i+1]; 
        arr[i+1] = arr[high]; 
        arr[high] = temp; 
  
        return i+1; 
    } 
  
  
    /* The main function that implements QuickSort() 
      arr[] --> Array to be sorted, 
      low  --> Starting index, 
      high  --> Ending index */
    void quickSort(int arr[], int low, int high) 
    { 
        if (low < high) 
        { 
            /* pi is partitioning index, arr[pi] is  
              now at right place */
            int pi = partition(arr, low, high); 
  
            // Recursively sort elements before 
            // partition and after partition 
            quickSort(arr, low, pi-1); 
            quickSort(arr, pi+1, high); 
        } 
            println("\nSorted Array via quicksort recursively");
            for(int x : arr)  
        {
             print(x+" ");
        }
     } 
    
}
