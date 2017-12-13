#include <stdlib.h>
#include <stdio.h>
#include <time.h>

typedef struct directed_acyclic_graph {
  int nv;
  int ne;
  int * edges;
} dag;

dag create_dag(int nv, int ne);
void build_edges(dag d);
void swap(int* edges, int i, int j);
void sort_edges(int* edges, int lb, int ub);
void DFS(dag d, int* vertices, int v, int* indices);
int is_connected(dag d);

void print_dag(dag d);

int check_duplicate(int* edges, int ne, int src, int dst);

int main() {
  // seed the rando number generator
  srand(time(NULL));
  // intialize
  dag d = create_dag(8, 12);
  printf("Connectedness = %i\n", is_connected(d));
  print_dag(d);

  return 0;
}

void print_dag(dag dag) {
  printf("The edges of the DAG are \n");
  for (int i = 0; i < dag.ne; i++)
    printf("%i --> %i\n", dag.edges[2*i + 0], dag.edges[2*i+1] );
}

dag create_dag(int nv, int ne) {
  dag d = {nv, ne, (int*) calloc(ne*2, sizeof(int))};
    build_edges(d);
    sort_edges(d.edges, 0, d.ne - 1);
  return(d);
}

void build_edges(dag d) {
    int src, dst;
    for (int i = 0; i < d.ne; ++i) {
      do {
        // node source cannot be the last one due to the topological ordering
        src = rand() % (d.nv - 1) + 1;
        // dst node has to occur after src. This procedure is also enusres there are no self loops
        dst = rand() % (d.nv - src) + (src + 1);
      } while (check_duplicate(d.edges, i, src, dst));
      d.edges[2*i + 0] = src;
      d.edges[2*i + 1] = dst;
    }
  }
// checks to see if potential edge is already in the set. return of 1 indicates that there was a duplicate
int check_duplicate(int *edges, int end, int src, int dst) {
  for (int i = 0; i < end; ++i) {
    if (edges[i*2] == src && edges[i*2 + 1] == dst)
      return 1;
  }
  return 0;
}

int is_connected(dag d) {
  int* vertices = (int*) calloc(d.nv, sizeof(d.nv));
  int* indices = (int*) calloc(d.nv, sizeof(d.nv));

  for (int i = 0; i < d.nv - 1; ++i) {
    for (int j = indices[i]; j < d.ne; ++j) {
      if (d.edges[2*j] == (i + 1) + 1) {
        indices[i + 1] = j;
        break;
      }
    }
  }
  DFS(d, vertices, 1, indices);
  int sum = 0;
  for (int i = 0; i < d.nv; ++i)
    sum += vertices[i];
  for (int i = 0; i < d.nv; i++) {
    printf("%i ", vertices[i]);
  }
  printf("\nSum %i\n", sum);
  free(vertices);
  free(indices);
  if (sum == d.nv) {
    return 1;
  }
  else
    return 0;
}

void DFS(dag d, int* vertices, int v, int* indices) {
  vertices[v - 1] = 1;
  for (int index = indices[v - 1]; index < indices[(v - 1) + 1]; ++index) {
    int w = d.edges[2*index + 1];
    if(!vertices[w - 1])
    DFS(d, vertices, w, indices);
  }
}


//Quicksort just for the edges of a dag. Not the fastest but gets the job done.
//qsort doesn't support a different swap function
void sort_edges(int* edges, int lb, int ub) {
  if (lb < ub) {
    int pivot = edges[2*ub];
    int i = lb - 1;
    for (int j = lb; j <= ub - 1; ++j) {
      if(edges[2*j] < pivot) {
          ++i;
          swap(edges, i, j);
      }
    }
    if (pivot < edges[2*(i + 1)])
      swap(edges, i + 1, ub);
    int p = i + 1;
    sort_edges(edges, lb, p - 1);
    sort_edges(edges, p + 1, ub);
  }
}

void swap(int* edges, int i , int j) {
  int tmp[2];
  tmp[0] = edges[2*i];
  tmp[1] = edges[2*i + 1];
  edges[2*i] = edges[2*j];
  edges[2*i + 1] = edges[2*j + 1];
  edges[2*j] = tmp[0];
  edges[2*j + 1] = tmp[1];
}
