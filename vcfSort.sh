#!/bin/sh

#vcf 파일에서 CHROM과 POS정보를 가지고 해당 행만 추출, vcf 저장

# 입력 VCF 파일 경로
input_vcf_file="final_output.vcf"
# 출력 VCF 파일 경로
output_vcf_file="filtered_output.vcf"
# 입력 CSV 파일 경로
input_csv_file="chrom_post.csv"

# awk 조건 생성
awk_conditions=""
while IFS=',' read -r chrom pos; do
    if [ "$chrom" != "CHROM" ]; then  # 헤더 행 무시
        if [ -n "$awk_conditions" ]; then
            awk_conditions="$awk_conditions || (\$1 == \"$chrom\" && \$2 == $pos)"
        else
            awk_conditions="(\$1 == \"$chrom\" && \$2 == $pos)"
        fi
    fi
done < "$input_csv_file"

# awk 명령 실행
awk '
BEGIN {FS="\t"; OFS="\t"}
/^#/ {print; next}
{
    if ('"$awk_conditions"') {
        print
    }
}
' "$input_vcf_file" > "$output_vcf_file"

echo "Filtered data saved to $output_vcf_file"

