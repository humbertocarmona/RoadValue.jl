#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char load_var_aux[1000];

char *load_var(FILE *arq, const char *varname){
  fscanf(arq,"%s",load_var_aux);
  if(strcmp(varname,"#")==0){
    return load_var_aux;
  };
  if (strcmp(load_var_aux,varname)!=0){
    fprintf(stderr,"File Error!\n");
    exit(1);
  };
  fscanf(arq,"%s",load_var_aux);
  return load_var_aux;
};

/*----------------------------------------------------------------------------*/

int main(int argc, char *argv[]){
  long Nv,Ne,Nn,Nb;
  long i;
  char aux[1000];
  double *vtc_x,*vtc_y;
  long *edg_v1,*edg_v2;
  long *nde_lbl,*bnd_n1,*bnd_n2;
  FILE *arq;

  if(argc!=2){
    printf("use: %s [graph.txt]\n",argv[0]);
    exit(1);
  };

  fprintf(stderr,"%s | Loading %s...\n",argv[0],argv[1]); /* cnae.txt */
  arq=fopen(argv[1],"r+t");
    load_var(arq,"#");
    Nv=atol(load_var(arq,"Nv="));
    Ne=atol(load_var(arq,"Ne="));
    Nn=atol(load_var(arq,"Nn="));
    Nb=atol(load_var(arq,"Nb="));
    vtc_x=(double *)calloc(Nv,sizeof(double));
    vtc_y=(double *)calloc(Nv,sizeof(double));
    for(i=0;i<Nv;i++){
      fscanf(arq,"%s",aux); vtc_x[i]=atof(aux); /* lon */
      fscanf(arq,"%s",aux); vtc_y[i]=atof(aux); /* lat */
      fscanf(arq,"%s",aux);                     /* cod. ibge */  
    };
    edg_v1=(long *)calloc(Ne,sizeof(long));
    edg_v2=(long *)calloc(Ne,sizeof(long));
    for(i=0;i<Ne;i++){
      fscanf(arq,"%s",aux); edg_v1[i]=atol(aux); /* vetice id 1 */
      fscanf(arq,"%s",aux); edg_v2[i]=atol(aux); /* vetice id 2 */
      fscanf(arq,"%s",aux);                      /* bond id */
    };
    nde_lbl=(long *)calloc(Nn,sizeof(long));
    for(i=0;i<Nn;i++){
      fscanf(arq,"%s",aux); nde_lbl[i]=atol(aux); /* vetice id 1 */
    };
    bnd_n1=(long *)calloc(Nb,sizeof(long));
    bnd_n2=(long *)calloc(Nb,sizeof(long));
    for(i=0;i<Nb;i++){
      fscanf(arq,"%s",aux); bnd_n1[i]=atol(aux); /* node id 1 */
      fscanf(arq,"%s",aux); bnd_n2[i]=atol(aux); /* node id 2 */
      fscanf(arq,"%s",aux);                      /* distance */
      fscanf(arq,"%s",aux);                      /* ce/br */
    };
  fclose(arq);
  fprintf(stderr,"%s | Ok!\n",argv[0]);

/*Print edges*/
  for(i=0;i<Ne;i++){
    printf("%lf %lf %lf %lf\n",vtc_x[edg_v1[i]],vtc_y[edg_v1[i]],vtc_x[edg_v2[i]]-vtc_x[edg_v1[i]],vtc_y[edg_v2[i]]-vtc_y[edg_v1[i]]);
  };

/*Print bonds*/
/*  for(i=0;i<Nb;i++){*/
/*    printf("%lf %lf %lf %lf\n",vtc_x[nde_lbl[bnd_n1[i]]],vtc_y[nde_lbl[bnd_n1[i]]],vtc_x[nde_lbl[bnd_n2[i]]]-vtc_x[nde_lbl[bnd_n1[i]]],vtc_y[nde_lbl[bnd_n2[i]]]-vtc_y[nde_lbl[bnd_n1[i]]]);*/
/*  };*/

  return 0;
};
