package com.hclust.java;

import java.lang.Math;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import org.apache.commons.math.linear.Array2DRowRealMatrix;
import org.apache.commons.math.linear.RealMatrix;


public class HClustering_PCR {

	static ArrayList<Double> lookup = new ArrayList<Double>();
	static ArrayList<String> Clusters = new ArrayList<String>();
	static ArrayList<Integer> tmp5 = new ArrayList<Integer>();
	static ArrayList<String> chklist = new ArrayList<String>();
	
	@SuppressWarnings("rawtypes")
	public static void main(String[] args) {
		
		double[][] array={{16.9699,17.0631,19.4206,19.4118,21.0632,21.1116,18.0104,18.0843},
				{14.9649,15.0808,13.7234,13.6306,14.3256,14.4576,18.6022,18.7681},
				{15.8703,15.9641,13.7951,13.6363,17.0782,17.155,15.0383,15.1404},
				{18.4159,18.5074,17.5309,17.3509,18.6738,18.8537,16.9497,17.0848},
				{16.0506,16.0259,14.3979,14.1961,10.3093,10.4504,17.0154,17.1293}};
		RealMatrix datamatrix = new Array2DRowRealMatrix(array);
		//{16.0506,16.0259,14.3979,14.1961,10.3093,10.4504,17.0154,17.1293}
		
		//System.out.print(array[0].length);
		int num_rows=datamatrix.getRowDimension();//num of rows in the matrix
		//int num_columns=array[0].length;//num of columns
		//Gene names
		String[] genenames = {"g1","g2","g3","g4","g5"};
		//this chklist is used to keep track of what all genese were already clustered
		for(int ab = 0; ab < genenames.length;ab++){
			chklist.add(genenames[ab]);
		}
		//Calculating Euclidean Distance Matrix
		double[][] EuclideanDM = calculateEuclideanDM(array,num_rows);
		
		int euclidnum_rows=EuclideanDM.length;
		//printing out the matrix
		for (int i = 0; i < array.length; i++) {
			for (int j = 0; j < array.length; j++) 
				System.out.printf("%9.4f ", EuclideanDM[i][j]);
			System.out.println();
		}
		
		//Performing Clustering
		
		int num_ofClusters = euclidnum_rows;
		HashMap<String,Double> clusters = new HashMap<String,Double>();
		HashMap<Integer,String> rowsalreadymerged = new HashMap<Integer,String>();
		
		while(num_ofClusters != 1){
			//In the lower triangle of the Euclidean Distance Matrix first find out the least distance
			int[] rowstobemerged = findLeastDistance(EuclideanDM);
			//find minimum of the two mergerows.
			tmp5.add(rowstobemerged[0]);tmp5.add(rowstobemerged[1]); 
			//System.out.println(euclidmatrix[rowstobemerged[0]][rowstobemerged[1]]);
			int minrow = Collections.min(tmp5); 
			int maxrow = Collections.max(tmp5);System.out.println(minrow);
			//System.out.println(maxrow);
			double height = EuclideanDM[maxrow][minrow];
			tmp5.clear();
			
			
			if(!rowsalreadymerged.containsKey(minrow)){
				String cluster = "("+ genenames[minrow] + "," + genenames[maxrow] + ")";
				rowsalreadymerged.put(minrow, cluster);
				clusters.put(cluster, height);
				chklist.remove(genenames[minrow]);chklist.remove(genenames[maxrow]);
			}else{
				if(chklist.size()!= 0){
					String in = "(" + rowsalreadymerged.get(minrow) + "," + genenames[maxrow] + ")";
					rowsalreadymerged.put(minrow, in);
					clusters.put(in, height);
					chklist.remove(genenames[maxrow]);
				}else{
					String in = "(" + rowsalreadymerged.get(minrow) + "," + rowsalreadymerged.get(maxrow) + ")";
					rowsalreadymerged.put(minrow, in);
					clusters.put(in,height);
					
				}
				
			}
			
			
			ArrayList<Double> singlelinkage = applySingleLinkage(EuclideanDM,minrow,maxrow);
			//update distance matrix
			for (int x =0; x < EuclideanDM.length; x++){
				for (int y =0; y < x; y++){
					if(x == minrow){
						EuclideanDM[x][y] = singlelinkage.get(y);
					}
					if(x == maxrow){
						EuclideanDM[x][y] = 100;
					}
					if (x == y){
						EuclideanDM[x][y] = 0.0;
					}
				}
			}
			
			for (int ij = 0; ij < EuclideanDM.length; ij++) {
				for (int jk = 0; jk <= ij; jk++) 
					System.out.printf("%9.4f ", EuclideanDM[ij][jk]);
				System.out.println();
			}
			
			num_ofClusters = num_ofClusters - 1;
		}
			
		//display hashmaps
		Set set = clusters.entrySet();
		Iterator it = set.iterator(); 
		while(it.hasNext()){
			Map.Entry me = (Map.Entry)it.next();
			System.out.println(me.getKey() + ":");
			System.out.println(me.getValue());
		}

	}
	
	//method to calculate Euclidean Distance Matrix
	//**********************************************
	public static double[][] calculateEuclideanDM(double[][] inputmatrix, int matrix_size){
		
		double[][] euclidmatrix= new double[matrix_size][matrix_size];
		for(int i = 0; i < matrix_size; i++){
			for(int j = 0; j < matrix_size; j++){
				double var1 = 0;
				for(int k = 0; k < matrix_size; k++){ 
					var1 = var1 + Math.pow((inputmatrix[i][k]-inputmatrix[j][k]),2);
				}
				double var2=Math.sqrt(var1);
				euclidmatrix[i][j]=var2;
				
			}
		}
		return euclidmatrix;
		
	}
	
	//method to find out the least distance in a given matrix
	//********************************************************
	public static int[] findLeastDistance(double[][] distmatrix){
		int mergerow1 = 0;
		double minval = 100000;
		int mergerow2 = 0;
		int distmatrixnum_rows = distmatrix.length;
		int[] tobemergedrows = new int[2];
		
		for(int p = 0; p < distmatrixnum_rows; p++){
			for (int q = 0; q < p; q++){
					double tmp = distmatrix[p][q];
					if(tmp <= minval){
						minval = tmp;
						if(minval != -1){
							mergerow1 = p;
							mergerow2 = q;
						}
					}	
			}
		}
		tobemergedrows[0] = mergerow1;
		tobemergedrows[1] = mergerow2;
		return (tobemergedrows);
	}
	
	//Single-Linkage Method
	//*********************
	public static ArrayList<Double> applySingleLinkage(double[][] distancematrix, int min_row, int max_row){
		ArrayList<Double> tmp1 = new ArrayList<Double>();
		ArrayList<Double> tmp2 = new ArrayList<Double>();
		ArrayList<Double> tmp3 = new ArrayList<Double>();
		ArrayList<Double> tmp4 = new ArrayList<Double>();
		int distmatrixnum_rows = distancematrix.length;
		for(int m = 0; m < distmatrixnum_rows; m++){
			for (int n = 0; n < m; n++){
				if (m == min_row){
					tmp1.add(distancematrix[m][n]);
				}
				if (m == max_row){
					tmp2.add(distancematrix[m][n]);
				}
			}
		}
		
		for(int abc = 0; abc < tmp1.size(); abc++){
			tmp3.add(tmp1.get(abc));
			tmp3.add(tmp2.get(abc));
			double minimumval = Collections.min(tmp3);
			tmp4.add(minimumval);
			tmp3.clear();
		}
		return(tmp4);
	}

}
