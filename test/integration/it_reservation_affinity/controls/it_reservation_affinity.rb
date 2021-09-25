# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')

expected_templates = 1
expected_disks = 1

expected_reservation_affinity_type = "SPECIFIC_RESERVATION"
expected_reservation_affinity_key = "compute.googleapis.com/reservation-name"
expected_reservation_affinity_value_size = 1
expected_reservation_affinity_value_0 = "it-reservation-affinity"

control "Instance Template" do
  title "Reservation Affinity Configuration"

  describe command("gcloud --project=#{project_id} compute instance-templates list --format=json --filter='name~^it-reservation-affinity*'") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }

    let!(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        []
      end
    end

    describe "number of templates" do
      it "should be #{expected_templates}" do
        expect(data.length).to eq(expected_templates)
      end
    end

    describe "reservation affinity type" do
      it "should be #{expected_reservation_affinity_type}" do
        expect(data[0]['properties']['reservationAffinity']['consumeReservationType']).to eq(expected_reservation_affinity_type)
      end
    end

    describe "reservation affinity key" do
      it "should be #{expected_reservation_affinity_key}" do
        expect(data[0]['properties']['reservationAffinity']['key']).to eq(expected_reservation_affinity_key)
      end
    end

    describe "reservation affinity values" do
      it "should be #{expected_reservation_affinity_value_size}" do
        expect(data[0]['properties']['reservationAffinity']['values'].length).to eq(expected_reservation_affinity_value_size)
      end
    end

    describe "reservation affinity value[0]" do
      it "should be #{expected_reservation_affinity_value_0}" do
        expect(data[0]['properties']['reservationAffinity']['values'][0]).to eq(expected_reservation_affinity_value_0)
      end
    end

  end
end
